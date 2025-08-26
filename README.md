# Solidity 基础语法与实战知识总结

语言: [中文](README.md) | [English](README.en.md)

本仓库是我学习 Solidity 过程中整理的示例与要点，涵盖从语法、类型、控制流、合约交互到常见模式与安全注意事项。本文将按仓库中的示例文件主题进行系统化总结，并给出实践建议与易错点提醒，帮助快速回顾与查阅。

- **环境建议**: 推荐使用 `solc >= 0.8.x`，IDE 使用 VS Code + Solidity 插件，或 Foundry/Hardhat 进行编译与测试。
- **编译配置**: 参见 `compiler_config.json`；产出的 ABI 可见 `artifacts/`。
- **阅读方式**: 每节含核心概念、关键 API/语法、注意事项、最佳实践。
- **图文教程与截图**: 本仓库每个主题对应的图文讲解与操作截图，见我的博客分类页面：[Solidity 专题（图文）](https://www.zyzy.info/categories/Solidity)。

## 使用 Remix 复现与调试

- 打开 Remix IDE，创建新文件，将本仓库某个 `.sol` 文件内容粘贴进去。
- 选择合适编译器版本（建议 `0.8.x`）并编译；按需启用 `Auto compile`。
- 切换至 `DEPLOY & RUN TRANSACTIONS`：
  - 选择 `ENVIRONMENT`（如 JavaScript VM/Injected Provider）
  - 如需测试接收 ETH 的合约，先在 Value 中设置金额
  - 点击 `Deploy` 部署，展开已部署合约，调用相应函数进行交互
- 出错排查：检查 `pragma solidity` 版本、数据位置（`memory`/`calldata`）、可见性、以及 Remix 控制台报错。
- 更完整的步骤、参数示例与截图，请参考博客分类：[Solidity 专题（图文）](https://www.zyzy.info/categories/Solidity)。

## 1. 入门与基本语法

- `01_hello.sol`、`01_counter.sol`
  - **合约结构**: `pragma`、`import`、`contract`、`state variables`、`functions`、`events`。
  - **函数可见性**: `public`/`external`/`internal`/`private`；默认是 `internal`。
  - **计数器**: 展示状态变量读写、函数修改状态、事件触发。
  - **最佳实践**: 
    - 状态变量命名清晰；
    - 改变状态的函数应考虑访问控制；
    - 事件用于链上可追踪的关键状态变更。

## 2. 基本数据类型与变量

- `02_dataType.sol`、`10_variable.sol`、`11_constant_immutable.sol`
  - **值类型**: `bool`、整数（`uint256`/`int256`）、`address`、`bytes32`、`enum` 等。
  - **引用类型**: `string`、`bytes`、`array`、`struct`、`mapping`。
  - **变量存储**: `storage`（链上存储）、`memory`（临时）、`calldata`（只读、外部函数参数）。
  - **常量**: `constant`（编译期写死）、`immutable`（部署时设定），节省 gas。
  - **实践**: 能用 `immutable`/`constant` 时不要用普通变量；函数入参与返回值尽量标注数据位置。
## 3. 函数与关键字

- `03_functions.sol`、`04_key_word.sol`
  - **函数类型**: `view`（读状态）、`pure`（不读不写）、`payable`（可接收 ETH）。
  - **修饰符**: `modifier` 复用前置/后置条件（见第 17 节）。
  - **返回值**: 命名返回、解构返回；尽量避免模糊命名。
  - **关键字**:
    - `this`（合约地址与外部调用上下文）
    - `super`（继承层级向上查找）
    - `delete`（将变量置为默认值）
    - `new`（创建合约/动态数组）

## 4. 控制流与循环

- `05_loop.sol`
  - **控制流**: `if/else`、`for`、`while`、`do-while`。
  - **Gas 注意**: 链上循环可能非常昂贵，优先考虑事件/日志、批处理拆分、多交易处理或 off-chain 计算。
  - **防范无限循环**: 明确上限；避免在循环中进行外部调用。

## 5. 映射与结构体

- `06_mapping.sol`、`07_struct_01.sol`、`07_struct_02.sol`、`14_UDVTAndStruct.sol`
  - **`mapping(Key => Value)`**: 只能在 `storage`，不可遍历；判断存在性用额外布尔位或约定值。
  - **`struct`**: 自定义聚合类型，可嵌套、配合 `mapping` 使用。
  - **UDVT（用户自定义值类型）**: `type MyUint is uint256;` 强化类型安全，封装操作。
  - **实践**: 需要遍历时维护辅助数组或索引；注意删除元素与稀疏数组的处理。

## 6. 全局变量与消息上下文

- `08_global_var.sol`、`08_MessageInfo.sol`
  - **区块上下文**: `block.number`、`block.timestamp`、`gasleft()` 等。
  - **交易/消息**: `msg.sender`、`msg.value`、`msg.data`、`tx.origin`（避免用于权限控制）。
  - **地址与余额**: `address(this).balance`、`payable(address)`。
  - **安全建议**: 不要信任 `block.timestamp` 的高精度随机性；避免使用 `tx.origin` 进行授权。

## 7. ABI、编码与解码

- `09_abi.sol`、`27_Abi.sol`
  - `abi.encode`/`abi.encodePacked`/`abi.encodeWithSelector`/`abi.encodeWithSignature`。
  - `abi.decode` 解码 bytes；与事件 topic/日志配合使用。
  - `artifacts/ABI.json` 与 `ABI_metadata.json` 可用于前端交互与工具集成。
  - **注意**: `encodePacked` 存在哈希碰撞风险，参与哈希前拼接分隔或定长字段。

## 8. 数据位置与拷贝语义

- `15_Data_Location.sol`
  - `storage` 引用同一存储位置；`memory` 为临时拷贝；`calldata` 只读高效。
  - 传参与返回值要选择合适位置以节省 gas 与确保只读语义。

## 9. 错误处理与断言

- `16_require_revert_assert.sol`、`25_TryCatch.sol`
  - `require(condition, "msg")` 参数校验；`revert("msg")` 提前返回；`assert(condition)` 不变量（失败视为严重错误）。
  - `try/catch` 捕获外部合约调用或 `new` 失败。
  - 自定义错误 `error MyError(arg);` 比字符串省 gas；使用 `revert MyError(arg);`。
## 10. 修饰符与继承

- `17_modifier.sol`、`18_Is.sol`
  - **modifier**: 提取前置/后置校验与逻辑复用，可组合多个 modifier；注意可重入风险顺序。
  - **继承**: `contract A is B, C` 支持多继承；线性化规则（C3）决定 `override` 解析顺序。
  - **override**: 多继承时需显式 `override(B, C)`；父合约函数需 `virtual`。
  - **构造参数**: 继承链上父合约构造器需要在子合约中显式传参。

## 11. 可见性

- `19_VisibleWords.sol`
  - `public`（内部外部均可见，自动生成 getter）、`external`（仅外部）、`internal`（本合约与子合约）、`private`（仅本合约）。
  - 变量 getter: 仅 `public` 状态变量自动生成 getter；`mapping` 等复杂类型返回受限。

## 12. 接口与抽象

- `20_interface.sol`、`IERC20.sol`
  - **接口**: 仅声明、无实现、不可包含状态变量；外部交互的强类型约束。
  - **抽象合约**: 部分函数未实现，供继承扩展；可包含状态与已实现逻辑。
  - **最佳实践**: 面向接口编程，降低耦合；跨合约交互优先依赖接口。

## 13. 接收与发送 ETH

- `21_sendETH.sol`
  - 接收 ETH: `receive()`（空 data）、`fallback()`（无匹配函数或有 data）。
  - 发送 ETH:
    - `transfer`（2300 gas、失败自动 revert）
    - `send`（返回 `bool`、需手动处理失败）
    - `call{value: v}("")`（推荐，灵活、返回 `(bool, bytes)`）
  - **安全**: 使用 Pull over Push（提款模式），配合重入保护；避免在回退函数中复杂逻辑。
## 14. 低级调用与委托调用

- `22_delegateCall.sol`、`23_CallContract.sol`
  - `call`：低级外部调用，返回 `(success, data)`；用于动态选择器、可自定义 gas/value。
  - `delegatecall`：在当前合约上下文执行目标合约代码，共享 `storage`/`msg.sender`/`msg.value`；常用于代理合约/可升级模式。
  - **风险**: 存储布局必须严格一致；外部调用需校验返回值与回退；避免将不可信地址 `delegatecall`。

## 15. 工厂模式与创建合约

- `24_ContractFactory.sol`
  - 使用 `new` 创建合约实例，保存地址，事件记录；
  - 可扩展为 Minimal Proxy/Clone（EIP-1167）降低部署 gas；
  - 可结合确定性创建（`create2`）实现可预测地址。

## 16. 库与复用

- `26_library.sol`
  - `library` 类似静态类，不能持有状态，内部函数 `internal` 可内联；
  - 使用 `using Lib for Type` 扩展方法；
  - External 库部署后通过 `DELEGATECALL` 复用代码。

## 17. 读写存储与全局读写

- `12_Read_Write.sol`
  - 演示状态写入、读取、事件日志；
  - 注意 `delete` 的语义是设为默认值；
  - 对映射/数组的增删改需关注 gas 与边界。

## 18. Gas 与优化

- `13_Gas.sol`、`29_Unchecked.sol`
  - 优化手段：短路求值、缓存状态变量到局部变量、减少存储写、使用 `immutable/constant`、事件替代存储、紧凑存储布局。
  - `unchecked`：在 `0.8+` 中关闭溢出检查以节约 gas，需确保安全边界。

## 19. 哈希、编码与签名

- `28_Keccak256.sol`、`SignatureNFT.sol`
  - `keccak256(abi.encodePacked(...))` 生成哈希，配合 ECDSA 恢复签名者。
  - EIP-191/EIP-712: 结构化签名与域分隔，防重放与跨域混淆。
  - 验签流程：消息域 -> 哈希 -> `ecrecover`/库函数恢复 -> 比对授权者地址。
## 20. 代币与 NFT 示例

- `IERC20.sol`、`ERC20.sol`、`MyCoin.sol`
  - 基本 ERC-20 接口与实现：`totalSupply`、`balanceOf`、`transfer`、`approve`、`transferFrom`。
  - 注意小数位 `decimals`（常为 18），铸造/销毁、权限控制与事件。
- `CM_ERC721.sol`、`CM2_ERC721_with_MetaData.sol`、`MyNFT.sol`、`SimpleERC721Merkle.sol`
  - ERC-721：`ownerOf`、`safeTransferFrom`、`tokenURI`、`_safeMint`；元数据扩展、Merkle 白名单铸造、签名铸造（见上节）。
  - 市场交互：授权给市场合约（`setApprovalForAll`）或单次授权（`approve`）。

## 21. ABI 与前端交互

- `artifacts/` 下的 `ABI.json`、`ABI_metadata.json` 可直接用于前端（ethers.js/viem/web3.js）。
- 典型交互：
```js
import { ethers } from "ethers";
const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, wallet);
const tx = await contract.someMethod(arg1, { value: ethers.parseEther("0.1") });
await tx.wait();
```

## 22. 常见安全注意事项清单

- **授权与所有权**: 使用 `Ownable`/`AccessControl`；避免将关键函数暴露为 `public`。
- **重入**: 使用互斥（检查-效果-交互模式、`ReentrancyGuard`），提款模式，尽量 `call` 后不依赖外部行为。
- **随机数**: 不要直接使用 `block.timestamp`/`blockhash`；使用 VRF 或 off-chain 随机性。
- **输入校验**: `require` 充分校验参数与状态；使用自定义错误减少 gas。
- **外部调用**: 校验返回、限制目标、使用接口、考虑失败回退路径。
- **算术**: 仅在确定安全时使用 `unchecked`；注意乘法溢出与精度。
- **升级与代理**: 严格遵守存储布局规则；初始化函数不可被重复调用。

## 23. 调试与工具

- **工具链**: Foundry/Hardhat/Truffle；静态分析（Slither）、审计辅助（Mythril）。
- **日志**: 使用事件，或 Foundry 的 `console2`, Hardhat 的 `console.log`（仅测试环境）。
- **版本管理**: 锁定编译器版本区间，避免不兼容变更。

## 24. 实践建议

- 小步提交与测试；接口先行，模块化设计；避免在循环中写存储或外部调用。
- 面向接口编程，抽象跨合约交互；谨慎对待权限与可升级性。
- 对外部输入与返回值保持怀疑；任何失败路径都应被覆盖测试。

---

### 附：文件与对应主题速查

- 基础：`01_hello.sol`、`01_counter.sol`
- 类型/变量：`02_dataType.sol`、`10_variable.sol`、`11_constant_immutable.sol`
- 函数/关键字：`03_functions.sol`、`04_key_word.sol`
- 控制流：`05_loop.sol`
- 映射/结构体/UDVT：`06_mapping.sol`、`07_struct_01.sol`、`07_struct_02.sol`、`14_UDVTAndStruct.sol`
- 全局变量：`08_global_var.sol`、`08_MessageInfo.sol`
- ABI/编码：`09_abi.sol`、`27_Abi.sol`
- 读写/数据位置：`12_Read_Write.sol`、`15_Data_Location.sol`
- 错误处理：`16_require_revert_assert.sol`、`25_TryCatch.sol`
- 修饰符/继承：`17_modifier.sol`、`18_Is.sol`
- 可见性：`19_VisibleWords.sol`
- 接口：`20_interface.sol`、`IERC20.sol`
- ETH 收发：`21_sendETH.sol`
- 调用与委托：`22_delegateCall.sol`、`23_CallContract.sol`
- 工厂：`24_ContractFactory.sol`
- 库：`26_library.sol`
- 哈希：`28_Keccak256.sol`
- Gas 与 unchecked：`13_Gas.sol`、`29_Unchecked.sol`
- 代币/NFT：`ERC20.sol`、`MyCoin.sol`、`CM_ERC721.sol`、`CM2_ERC721_with_MetaData.sol`、`MyNFT.sol`、`SimpleERC721Merkle.sol`、`SignatureNFT.sol`
