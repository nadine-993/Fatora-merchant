enum NotificationType {
  NULL,
  DelegationGranted,
  DelegationEnded,
  ApprovalRequestAdded,
  ApprovalRequestRejected,
  ApprovalRequestApproved,
  ItemMinQuantityReached,
  TaskAssigned,
  TaskLateFirstReminder,
  TaskLateSecondReminder,
  TaskLateEscalation
}

enum NotificationsState { Unread, Read }
