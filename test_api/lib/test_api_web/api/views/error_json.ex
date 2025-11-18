defmodule TestApiWeb.Api.ErrorApiJSON do
   # 404 Not Found
   def render("404.json", _assigns) do
    %{
      error: %{
        status: 404,
        message: "Not Found",
        detail: "The requested resource could not be found"
      }
    }
  end

  # 422 Unprocessable Entity - Changeset errors
  def render("422.json", %{changeset: changeset}) do
    %{
      error: %{
        status: 422,
        message: "Unprocessable Entity",
        detail: "Validation failed",
        errors: translate_errors(changeset)
      }
    }
  end

  # 500 Internal Server Error
  def render("500.json", _assigns) do
    %{
      error: %{
        status: 500,
        message: "Internal Server Error",
        detail: "An unexpected error occurred"
      }
    }
  end

  # Generic error handler - catches all other status codes
  def render(template, _assigns) do
    status = String.to_integer(String.replace(template, ".json", ""))
    %{
      error: %{
        status: status,
        message: Phoenix.Controller.status_message_from_template(template),
        detail: Phoenix.Controller.status_message_from_template(template)
      }
    }
  end

  # Helper function to translate Ecto changeset errors to a readable format
  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
