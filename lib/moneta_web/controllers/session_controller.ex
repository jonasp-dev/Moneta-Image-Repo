defmodule MonetaWeb.SessionController do
    use MonetaWeb, :controller
    
    alias Moneta.{Auth, Repo}
    
    def new(conn, _params) do
      case Auth.signed_in?(conn) do
        true ->
          conn
          |> put_flash(:info, "Must be logged in to upload an image")
          |> redirect(to: Routes.gallery_path(conn, :index))
        false ->
          render(conn, "new.html")
      end
    end

    def create(conn, %{"session" => auth_params}) do
        case Auth.login(auth_params) do
        {:ok, user} ->
          conn = 
          conn
          |> put_session(:current_user_id, user.userid)
       

        redirect(conn, to: Routes.gallery_path(conn, :index))
          
        :error ->
          conn
          |> put_flash(:error, "There was a problem with your username/password")
          |> render("new.html")
        end
      end

      def delete(conn, _params) do
        conn
        |> delete_session(:current_user_id)
        |> put_flash(:info, "Signed out successfully.")
        |> redirect(to: Routes.gallery_path(conn, :index))
      end

end