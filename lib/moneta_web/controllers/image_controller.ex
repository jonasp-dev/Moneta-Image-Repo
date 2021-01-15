defmodule MonetaWeb.ImageController do
    use MonetaWeb, :controller
    
    alias Moneta.{Auth, Image, Repo, Users}

    def index(conn, _params) do
      render(conn, "index.html")
    end

    def new(conn, _params) do
        case Auth.signed_in?(conn) do
            true->
                render(conn, "new.html")
            false ->
                conn
                |> put_flash(:info, "Must be logged in to upload an image")
                |> redirect(to: Routes.gallery_path(conn, :index))
            end
    end

    #%{"image" => %Plug.Upload{}=upload}
    def create(conn, %{"images" => images} = upload) do
        user_id = conn.private.plug_session["current_user_id"]

        user = Users.get_user_by_userid!(user_id)
        Enum.each(images, fn image ->   
            case Moneta.create_upload_from_plug_upload(image, user) do
                {:ok, upload}->
                  IO.puts "SUCCEED TO UPLOAD"
                  put_flash(conn, :info, "file uploaded correctly")
                  
            
                {:error, reason}->
                IO.puts "FAILED TO UPLOAD"
                  put_flash(conn, :error, "error upload file: #{inspect(reason)}")
              end
        end)

        redirect(conn, to: Routes.gallery_path(conn, :index))

    end
      

    def delete(conn, _param) do
        
    end

    defp save_file(conn, temp_path, file_name) do
        case File.exists?(temp_path) do
            true ->
                File.cp(temp_path, "priv/static/images/#{file_name}")
            false ->
                IO.puts "error"

        end
    end
  end