// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiquidityPool is ERC20 {
    IERC20 public etherToken;
    IERC20 public artiumToken;

    constructor(address _artiumToken) ERC20("Liquidity Pool", "LP") payable {
        require(
            _artiumToken != address(0),
            "Token address passed is a null address"
        );
        etherToken = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        artiumToken = IERC20(_artiumToken);
    }

    // 1 Ether = 10,000 Artium
    uint256 constant ETH_TO_ARTIUM_RATIO = 10000;

    function getReserve() public view returns (uint256) {
        return IERC20(artiumToken).balanceOf(address(this));
    }

    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint256 liquidity;
        uint256 ethBalance = address(this).balance;
        uint256 artiumReserve = getReserve();

        if (artiumReserve == 0) {
            artiumToken.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance;
        } else {
            uint256 ethReserve = ethBalance - msg.value;
            uint256 artiumTokenAmount = (msg.value * artiumReserve) /
                (ethReserve);
            require(
                _amount >= artiumTokenAmount,
                "Amount of tokens sent is less than the minimum tokens required"
            );
            artiumToken.transferFrom(
                msg.sender,
                address(this),
                artiumTokenAmount
            );

            liquidity = (totalSupply() * msg.value) / ethReserve;
        }
        _mint(msg.sender, liquidity);
        return liquidity;
    }

    function removeLiquidity(uint256 _amount)
        public
        returns (uint256, uint256)
    {
        require(_amount > 0, "_amount should be greater than zero");
        uint256 ethReserve = address(this).balance;
        uint256 _totalSupply = totalSupply();

        uint256 ethAmount = (ethReserve * _amount) / _totalSupply;

        uint256 artiumAmount = (getReserve() * _amount) / _totalSupply;

        _burn(msg.sender, _amount);

        (bool sent, bytes memory data) = payable(msg.sender).call{
            value: ethAmount
        }("");
        require(sent, "Failed to send Ether");
        artiumToken.transfer(msg.sender, artiumAmount);

        return (ethAmount, artiumAmount);
    }

    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 ether, "Input reserve running low");
        require(outputReserve > 0 ether, "Output reserve running low");

        uint256 inputAmountWithFee = inputAmount * 99;

        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;

        return numerator / denominator;
    }

    function ethToArtium(uint256 _minTokens) public payable {
        uint256 tokenReserve = getReserve();

        uint256 tokensBought = getAmountOfTokens(
            msg.value,
            address(this).balance - msg.value,
            tokenReserve
        );

        require(tokensBought >= _minTokens, "Insufficient output amount");

        artiumToken.transfer(msg.sender, tokensBought);
    }

    function artiumToEth(uint256 _tokensSold, uint256 _minEth) public {
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmountOfTokens(
            _tokensSold,
            tokenReserve,
            address(this).balance
        );

        require(ethBought >= _minEth, "Insufficient output amount");

        artiumToken.transferFrom(msg.sender, address(this), _tokensSold);

        (bool sent, bytes memory data) = payable(msg.sender).call{
            value: ethBought
        }("");
        require(sent, "Failed to send Ether");
    }
}
