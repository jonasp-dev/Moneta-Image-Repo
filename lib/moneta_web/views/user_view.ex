defmodule MonetaWeb.UserView do
  use MonetaWeb, :view
  alias Moneta.Image
  alias MonetaWeb.Router.Helpers, as: Routes

  def get_img_path(%{id: id, filename: filename} = image) do
    ["/images/", "#{id}-#{filename}"]
    |> Path.join()
  end
end
