# Solidity Fundamentals and Practical Notes

Language: [English](README.en.md) | [中文](README.md)

This repository contains my notes and examples while learning Solidity, covering everything from syntax, types, control flow, and contract interactions to common patterns and security considerations. It summarizes each topic by referencing the example files in this repo, with key concepts, APIs/keywords, pitfalls, and best practices.

- **Environment**: Use `solc >= 0.8.x`. IDE: VS Code + Solidity extension. Consider Foundry/Hardhat for compilation and testing.
- **Compiler settings**: See `compiler_config.json`. Generated ABIs are in `artifacts/`.
- **Reading guide**: Each section includes core concepts, important APIs/keywords, notes, and best practices.
- **Full tutorials with screenshots**: Each topic in this repo has a matching blog post with step-by-step instructions and screenshots: [Solidity Series (Blog)](https://www.zyzy.info/categories/Solidity).

## Using Remix to reproduce and debug

- Open Remix IDE, create a file, and paste the content of a `.sol` file from this repo.
- Select a compatible compiler version (prefer `0.8.x`) and compile; enable Auto compile if desired.
- Go to `DEPLOY & RUN TRANSACTIONS`:
  - Pick `ENVIRONMENT` (e.g., JavaScript VM / Injected Provider)
  - For contracts receiving ETH, set Value before function calls
  - Click `Deploy`, then expand the deployed instance and interact with functions
- Troubleshooting: Check `pragma solidity` range, data locations (`memory`/`calldata`), visibility, and Remix console messages.
- For detailed steps, parameters, and screenshots, see: [Solidity Series (Blog)](https://www.zyzy.info/categories/Solidity).

## 1. Getting Started and Basics

- `01_hello.sol`, `01_counter.sol`
  - **Contract structure**: `pragma`, `import`, `contract`, `state variables`, `functions`, `events`.
  - **Function visibility**: `public`/`external`/`internal`/`private` (default for functions is `internal`).
  - **Counter**: Demonstrates state reads/writes, state-changing functions, and events.
  - **Best practices**:
    - Use clear names for state variables
    - Apply access control to state-changing functions
    - Emit events for on-chain observable state changes
## 2. Basic Data Types and Variables

- `02_dataType.sol`, `10_variable.sol`, `11_constant_immutable.sol`
  - **Value types**: `bool`, integers (`uint256`/`int256`), `address`, `bytes32`, `enum`, etc.
  - **Reference types**: `string`, `bytes`, `array`, `struct`, `mapping`.
  - **Data locations**: `storage` (on-chain), `memory` (temporary), `calldata` (read-only, external fn params).
  - **Constants**: `constant` (compile-time), `immutable` (deployment-time), both help save gas.
  - **Practice**: Prefer `immutable`/`constant` when applicable; always annotate data location for params/returns.

## 3. Functions and Keywords

- `03_functions.sol`, `04_key_word.sol`
  - **Function types**: `view` (read-only), `pure` (no read/write), `payable` (can receive ETH).
  - **Modifiers**: See Section 10 for details.
  - **Returns**: Named returns, destructuring; avoid ambiguous names.
  - **Keywords**:
    - `this` (contract address and external-call context)
    - `super` (search up the inheritance chain)
    - `delete` (reset to default value)
    - `new` (deploy contract / create dynamic arrays)

## 4. Control Flow and Loops

- `05_loop.sol`
  - **Control flow**: `if/else`, `for`, `while`, `do-while`.
  - **Gas notes**: On-chain loops can be expensive. Prefer events/logs, batch splitting, multi-tx flows, or off-chain computation.
  - **Avoid infinite loops**: Set explicit limits; avoid external calls inside loops.
## 5. Mappings and Structs

- `06_mapping.sol`, `07_struct_01.sol`, `07_struct_02.sol`, `14_UDVTAndStruct.sol`
  - **`mapping(Key => Value)`**: Only in `storage`; not iterable. Use auxiliary flags or sentinel values to check existence.
  - **`struct`**: Custom aggregate types, can nest and combine with `mapping`.
  - **UDVT (User-Defined Value Types)**: `type MyUint is uint256;` for stronger type safety and encapsulation.
  - **Practice**: Maintain helper arrays or indexes when iteration is required; handle deletion and sparse arrays carefully.

## 6. Global Variables and Message Context

- `08_global_var.sol`, `08_MessageInfo.sol`
  - **Block context**: `block.number`, `block.timestamp`, `gasleft()`.
  - **Tx/message**: `msg.sender`, `msg.value`, `msg.data`, `tx.origin` (do not use for authorization).
  - **Address and balance**: `address(this).balance`, `payable(address)`.
  - **Security**: Do not rely on `block.timestamp` as a secure randomness source; avoid `tx.origin` for auth.

## 7. ABI, Encoding, and Decoding

- `09_abi.sol`, `27_Abi.sol`
  - `abi.encode` / `abi.encodePacked` / `abi.encodeWithSelector` / `abi.encodeWithSignature`.
  - `abi.decode` for bytes; often paired with event topics/logs.
  - `artifacts/ABI.json` and `ABI_metadata.json` can be used by frontends and tooling.
  - **Note**: `encodePacked` can lead to hash collisions. Add delimiters or use fixed-size fields before hashing.

## 8. Data Locations and Copy Semantics

- `15_Data_Location.sol`
  - `storage` references the same storage slot; `memory` creates a temporary copy; `calldata` is read-only and cheap.
  - Choose locations wisely for params/returns to save gas and preserve immutability.
## 9. Error Handling and Assertions

- `16_require_revert_assert.sol`, `25_TryCatch.sol`
  - `require(condition, "msg")` for input/state validation; `revert("msg")` for early exits; `assert(condition)` for invariants (failing implies serious bugs).
  - `try/catch` to capture failures from external calls or `new`.
  - Custom errors `error MyError(arg);` are cheaper than strings; use `revert MyError(arg);`.

## 10. Modifiers and Inheritance

- `17_modifier.sol`, `18_Is.sol`
  - **modifier**: Extract pre/post checks and reuse logic; beware of reentrancy order.
  - **Inheritance**: `contract A is B, C` supports multiple inheritance; C3 linearization decides `override` resolution.
  - **override**: Explicitly declare `override(B, C)` in diamond inheritance; parent functions must be `virtual`.
  - **Constructor params**: Pass parent constructor args explicitly in child contracts.

## 11. Visibility

- `19_VisibleWords.sol`
  - `public` (internal+external, auto-generated getter), `external` (external only), `internal` (this + children), `private` (this only).
  - Variable getters: Only `public` state variables get auto getters; complex types like `mapping` have limits.

## 12. Interfaces and Abstract Contracts

- `20_interface.sol`, `IERC20.sol`
  - **Interfaces**: Declarations only, no implementation, no state vars; enforce strong typing for external calls.
  - **Abstract contracts**: Some functions unimplemented; can include state and implemented logic.
  - **Practice**: Program to interfaces to reduce coupling; prefer interface-based cross-contract interactions.
## 13. Receiving and Sending ETH

- `21_sendETH.sol`
  - Receive ETH: `receive()` (empty data), `fallback()` (no match or has data).
  - Send ETH:
    - `transfer` (2300 gas, auto-revert on failure)
    - `send` (returns `bool`; handle failure manually)
    - `call{value: v}("")` (recommended; flexible; returns `(bool, bytes)`)
  - **Security**: Prefer pull over push (withdraw pattern), add reentrancy guards; keep fallback logic minimal.

## 14. Low-level Calls and Delegatecall

- `22_delegateCall.sol`, `23_CallContract.sol`
  - `call`: Low-level external call returning `(success, data)`; used for dynamic selectors, custom gas/value.
  - `delegatecall`: Executes target code in the caller's context, sharing `storage`/`msg.sender`/`msg.value`; used in proxies/upgrades.
  - **Risks**: Storage layout must match; verify return values and handle fallbacks; never delegatecall to untrusted addresses.

## 15. Factory Pattern and Contract Creation

- `24_ContractFactory.sol`
  - Use `new` to deploy instances, store addresses, and emit events.
  - Consider Minimal Proxy/Clones (EIP-1167) to save deployment gas.
  - Combine with deterministic deployment (`create2`) for predictable addresses.

## 16. Libraries and Reuse

- `26_library.sol`
  - `library` is like a static class: no state, internal functions may inline.
  - Use `using Lib for Type` to extend methods.
  - External libraries are deployed once and used via `DELEGATECALL`.

## 17. Reading/Writing Storage

- `12_Read_Write.sol`
  - Demonstrates state writes/reads and events.
  - `delete` sets values to default.
  - Consider gas and bounds when mutating maps/arrays.
## 18. Gas and Optimizations

- `13_Gas.sol`, `29_Unchecked.sol`
  - Techniques: short-circuiting, caching state to local variables, reducing storage writes, using `immutable/constant`, emitting events instead of storage, compact storage layout.
  - `unchecked`: Disable overflow checks in `0.8+` to save gas when safe bounds are guaranteed.

## 19. Hashing, Encoding, and Signatures

- `28_Keccak256.sol`, `SignatureNFT.sol`
  - `keccak256(abi.encodePacked(...))` to hash, then recover signer with ECDSA.
  - EIP-191/EIP-712: Structured data signing with domain separators; prevents replay and domain mixing.
  - Verification flow: domain -> hash -> `ecrecover`/library helpers -> compare signer address.

## 20. Tokens and NFTs

- `IERC20.sol`, `ERC20.sol`, `MyCoin.sol`
  - Basics: `totalSupply`, `balanceOf`, `transfer`, `approve`, `transferFrom`.
  - Mind `decimals` (often 18), mint/burn, access control, and events.
- `CM_ERC721.sol`, `CM2_ERC721_with_MetaData.sol`, `MyNFT.sol`, `SimpleERC721Merkle.sol`
  - ERC-721: `ownerOf`, `safeTransferFrom`, `tokenURI`, `_safeMint`; metadata extension, Merkle whitelist minting, signature-based minting.
  - Market interaction: approve marketplaces (`setApprovalForAll`) or per-token approvals (`approve`).

## 21. ABI and Frontend Integration

- `artifacts/ABI.json`, `artifacts/ABI_metadata.json` work with ethers.js/viem/web3.js.
- Typical interaction:
```js
import { ethers } from "ethers";
const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, wallet);
const tx = await contract.someMethod(arg1, { value: ethers.parseEther("0.1") });
await tx.wait();
```

## 22. Common Security Checklist

- **Ownership and access control**: Use `Ownable`/`AccessControl`; avoid exposing sensitive functions as `public`.
- **Reentrancy**: Follow checks-effects-interactions, use withdraw patterns, and reentrancy guards.
- **Randomness**: Do not use `block.timestamp`/`blockhash` directly; prefer VRF or off-chain randomness.
- **Input validation**: Use `require` thoroughly; prefer custom errors to save gas.
- **External calls**: Check return values, restrict targets, use interfaces, and handle failure paths.
- **Arithmetic**: Only use `unchecked` with proven safety; mind multiplication overflow and precision.
- **Upgradeability**: Follow storage layout rules; protect initializers from being called twice.

## 23. Tooling and Debugging

- **Toolchains**: Foundry/Hardhat/Truffle; static analysis with Slither; Mythril for audit assistance.
- **Logging**: Use events, or Foundry `console2`/Hardhat `console.log` (test only).
- **Versioning**: Pin compiler version ranges to avoid breaking changes.

## 24. Practical Advice

- Commit and test in small steps; design interfaces first; avoid storage writes or external calls inside loops.
- Program to interfaces; be cautious with permissions and upgradeability.
- Treat external input/returns skeptically; cover every failure path with tests.

---

### Appendix: File-to-Topic Quick Reference

- Basics: `01_hello.sol`, `01_counter.sol`
- Types/Variables: `02_dataType.sol`, `10_variable.sol`, `11_constant_immutable.sol`
- Functions/Keywords: `03_functions.sol`, `04_key_word.sol`
- Control flow: `05_loop.sol`
- Mapping/Struct/UDVT: `06_mapping.sol`, `07_struct_01.sol`, `07_struct_02.sol`, `14_UDVTAndStruct.sol`
- Global variables: `08_global_var.sol`, `08_MessageInfo.sol`
- ABI/Encoding: `09_abi.sol`, `27_Abi.sol`
- Read/Write & Data location: `12_Read_Write.sol`, `15_Data_Location.sol`
- Error handling: `16_require_revert_assert.sol`, `25_TryCatch.sol`
- Modifiers/Inheritance: `17_modifier.sol`, `18_Is.sol`
- Visibility: `19_VisibleWords.sol`
- Interfaces: `20_interface.sol`, `IERC20.sol`
- ETH I/O: `21_sendETH.sol`
- Calls/Delegatecall: `22_delegateCall.sol`, `23_CallContract.sol`
- Factory: `24_ContractFactory.sol`
- Library: `26_library.sol`
- Hashing: `28_Keccak256.sol`
- Gas & unchecked: `13_Gas.sol`, `29_Unchecked.sol`
- Tokens/NFTs: `ERC20.sol`, `MyCoin.sol`, `CM_ERC721.sol`, `CM2_ERC721_with_MetaData.sol`, `MyNFT.sol`, `SimpleERC721Merkle.sol`, `SignatureNFT.sol`
