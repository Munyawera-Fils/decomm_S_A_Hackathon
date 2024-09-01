import ICRC7 "mo:icrc7-mo";
import ICRC37 "mo:icrc37-mo";

module Types {
    public type Account = ICRC7.Account;
    public type Environment = ICRC7.Environment;
    public type Value = ICRC7.Value;
    public type NFT = ICRC7.NFT;
    public type NFTShared = ICRC7.NFTShared;
    public type NFTMap = ICRC7.NFTMap;
    public type OwnerOfResponse = ICRC7.Service.OwnerOfResponse;
    public type OwnerOfRequest = ICRC7.Service.OwnerOfRequest;
    public type TransferArgs = ICRC7.Service.TransferArg;
    public type TransferResult = ICRC7.Service.TransferResult;
    public type TransferError = ICRC7.Service.TransferError;
    public type BalanceOfRequest = ICRC7.Service.BalanceOfRequest;
    public type BalanceOfResponse = ICRC7.Service.BalanceOfResponse;
    public type TokenApproval = ICRC37.Service.TokenApproval;
    public type CollectionApproval = ICRC37.Service.CollectionApproval;
    public type ApprovalInfo = ICRC37.Service.ApprovalInfo;
    public type ApproveTokenResult = ICRC37.Service.ApproveTokenResult;
    public type ApproveTokenArg = ICRC37.Service.ApproveTokenArg; 
    public type ApproveCollectionArg = ICRC37.Service.ApproveCollectionArg; 
    public type IsApprovedArg = ICRC37.Service.IsApprovedArg;
    public type ApproveCollectionResult = ICRC37.Service.ApproveCollectionResult;
    public type RevokeTokenApprovalArg = ICRC37.Service.RevokeTokenApprovalArg;
    public type RevokeCollectionApprovalArg = ICRC37.Service.RevokeCollectionApprovalArg;
    public type TransferFromArg = ICRC37.Service.TransferFromArg;
    public type TransferFromResult = ICRC37.Service.TransferFromResult;
    public type RevokeTokenApprovalResult = ICRC37.Service.RevokeTokenApprovalResult;
    public type RevokeCollectionApprovalResult = ICRC37.Service.RevokeCollectionApprovalResult;
}

