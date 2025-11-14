defmodule TestApiWeb.Router do
  use TestApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TestApiWeb.Api do
    pipe_through :api
    post("/systems", SystemApiController, :create)
    get("/systems", SystemApiController, :index)
    get("/systems/:id", SystemApiController, :show)
    post("/users", UserApiController, :create)
    get("/users", UserApiController, :index)
    get("/users/:id", UserApiController, :show)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:test_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TestApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
