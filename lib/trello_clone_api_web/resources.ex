defmodule TrelloCloneApiWeb.Resources do
  use PolicyWonk.Resource
  use PolicyWonk.Load
  alias TrelloCloneApiWeb.ErrorHandler

  alias TrelloCloneApiWeb.Resources.BoardResources

  def resource(conn, resource, params)
      when resource in [
            {:board, :permission},
            {:board_permission, :permission},
            {:list, :permission},
            {:comment, :permission}
           ],
      do: BoardResources.resource(conn, resource, params)


  def resource_error(conn, _resource, _params), do: resource_error(conn, nil)

  def resource_error(conn, resource_id) do
    ErrorHandler.resource_not_found(conn, resource_id)
  end
end
