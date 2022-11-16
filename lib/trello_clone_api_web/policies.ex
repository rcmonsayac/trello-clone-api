defmodule TrelloCloneApiWeb.Policies do
  use PolicyWonk.Policy
  use PolicyWonk.Enforce
  alias TrelloCloneApiWeb.ErrorHandler

  alias TrelloCloneApiWeb.Policies.BoardPolicies


  def policy(assigns, identifier)
      when identifier in [
             :read_board,
             :update_board,
             :manage_board
           ],
      do: BoardPolicies.policy(assigns, identifier)


  def policy(_assigns, _identifier), do: raise("Policy does not exist")

  def policy_error(conn, error_code), do: ErrorHandler.policy_error(conn, error_code)
end
