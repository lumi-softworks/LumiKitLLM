import Foundation

/// 本地模型驻留状态查询（可选能力）。
///
/// 把模型权重载入内存/显存的本地供应商可以实现本协议，让发送链路区分
/// 「发送后才会把模型加载进内存」与「模型已驻留内存」两种情况：
/// 前者可能瞬间占用数 GB 内存、引发系统级卡顿，值得在提交前二次确认；
/// 后者没有加载开销，不必重复打扰。
///
/// 查询方通过 `LLMManaging.provider(id:)` 取得供应商实例后按本协议条件
/// 转换；未实现的供应商视为「驻留状态未知」，由查询方自行决定保守策略
/// （例如仍弹确认）。
@MainActor
public protocol LLMModelResidencyProviding: AnyObject {
    /// 指定模型当前是否已驻留内存。
    ///
    /// - Parameter modelID: 供应商 API 模型名（`LLMModelInfo.id`）。
    /// - Returns: 已驻留返回 `true`，未驻留返回 `false`；无法判断时返回 `nil`。
    func isModelResident(modelID: String) -> Bool?
}
