defmodule MonetaWeb.UserController do
  use MonetaWeb, :controller

  alias Moneta.{Auth, Users, Repo}
  alias Moneta.Users.User

  def new(conn, _params) do
    case Auth.signed_in?(conn) do
      true->
        conn
          |> put_flash(:info, "Must be logged in to upload an image")
          |> redirect(to: Routes.gallery_path(conn, :index))
      false ->
        changeset = Users.change_user(%User{})
        render(conn, "new.html", changeset: changeset)
      end
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id,  user.id)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.gallery_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def show(conn, %{"id" => id}) do
    user = Users.get_user_by_id!(id)
    images = Ecto.assoc(user, :images)
    |> Repo.all
    render(conn, "show.html", images: images)
  end

end
