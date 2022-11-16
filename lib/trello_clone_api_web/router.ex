defmodule TrelloCloneApiWeb.Router do
  use TrelloCloneApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_query_params
  end

  pipeline :auth do
    plug TrelloCloneApiWeb.Auth.Pipeline
    plug TrelloCloneApiWeb.Auth.CurrentUser
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug :fetch_query_params
  end


  scope "/api", TrelloCloneApiWeb do
    pipe_through [:api]
    post "/register", UserController, :register
    post "/signin", SessionController, :signin
  end

  scope "/api", TrelloCloneApiWeb do
    pipe_through [:api, :auth]

    get "/test", TestController, :test
    post "/logout", SessionController, :logout

    get "/users/search", UserController, :search

    resources "/boards", BoardController, except: [:new, :edit]

    resources "/boards/:board_id/board_permissions", BoardPermissionController,
      except: [:new, :edit, :show],
      param: "id"

    get "/board_permissions/:board_id/user/:user_id", BoardPermissionController, :show
    get "/boards/:board_id/members", BoardPermissionController, :index

    resources "/boards/:board_id/lists", ListController,
      except: [:new, :edit],
      param: "id"

    resources "/boards/:board_id/tasks", TaskController,
      except: [:new, :edit],
      param: "id"

    # resources "/tasks", TaskController, except: [:new, :edit]
    # get "/boards/:board_id/tasks", TaskController, :index

    resources "/comments", CommentController, except: [:new, :edit]
    get "/tasks/:task_id/comments", CommentController, :index

  end
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TrelloCloneApiWeb.Telemetry
    end
  end
end
