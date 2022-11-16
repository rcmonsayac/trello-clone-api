import EctoEnum

defenum(TrelloCloneApi.PermissionType, :permission_type, [
  :manage,
  :write,
  :read
])

defenum(TrelloCloneApi.TaskStatus, :status, [
  :not_started,
  :in_progress,
  :for_review,
  :blocked,
  :done
])
