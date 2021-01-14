defmodule MonetaWeb.GalleryController do
  use MonetaWeb, :controller
  alias Moneta.Repo
  def index(conn, _params) do

    images = Repo.all(Moneta.Image)
    render(conn, "index.html", images: images)
  end
end
