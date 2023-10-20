'use client'

import { BaseError } from 'viem'
import { useContractWrite, useWaitForTransaction, usePrepareContractWrite } from 'wagmi'
import { Greeter__factory } from '../../typechain'
import { stringify } from '../utils/stringify'

import contractDetails from '../info/contractDetails.json'
import { useState } from 'react'

export function WriteContract() {
  const [currentValue, setCurrentValue] = useState('')

  const { config } = usePrepareContractWrite({
    address: contractDetails.contractAddress as `0x${string}`,
    abi: Greeter__factory.abi,
    functionName: 'setGreetings',
    args: [currentValue],
  })
  const { data, isLoading, isSuccess, write } = useContractWrite(config)

  const { data: receipt, isLoading: isPending } = useWaitForTransaction({ hash: data?.hash })

  function handleChange(evt) {
    setCurrentValue(evt.currentTarget.value)
  }
  return (
    <>
      <form
        className="m-4 flex"
        onSubmit={e => {
          e.preventDefault()
          write()
        }}
      >
        <input
          value={currentValue}
          onChange={evt => handleChange(evt)}
          className="mr-0 rounded-l-lg border-b border-l border-t border-gray-200 bg-white p-4 text-gray-800"
          placeholder="Enter new greet"
        />
        <button
          type="submit"
          className="rounded-r-lg border-b border-r  border-t border-yellow-500 bg-yellow-400 p-4 px-8 font-bold uppercase text-gray-800"
        >
          Set Greet
        </button>
      </form>
      {isLoading && <div>Check wallet...</div>}
      {isPending && <div>Transaction pending...</div>}
      {isSuccess && (
        <>
          <div>Transaction Hash: {data?.hash}</div>
          <div>
            Transaction Receipt: <pre>{stringify(receipt, null, 2)}</pre>
          </div>
        </>
      )}
    </>
  )
}
