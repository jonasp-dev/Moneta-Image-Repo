defmodule Moneta do
  alias Moneta.{Image, Repo}
 
  def create_upload_from_plug_upload(%Plug.Upload{
    filename: filename,
    path: tmp_path,
    content_type: content_type,
  }, user_id) do

    # tags = generate_tags(tmp_path)

    # IO.inspect tags
    hash =
      File.stream!(tmp_path, [], 2048)
      |> Image.sha256()
    
    Repo.transaction fn ->
      with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
      {:ok, image} <- 
        %Image{} |> Image.changeset(%{
          filename: filename, content_type: content_type,
          hash: hash, size: size, user: user_id}) 
        |> Repo.insert(),
            
      :ok <- File.cp(
          tmp_path,
          Image.local_path(image.id, filename)
      )

      do
        {:ok, image}

      else
        {:error, reason} -> 
          IO.inspect reason
          Repo.rollback(reason)
          
      end
    end
    
     
  end

#   defp upload_image(image_path) do
#     url = "https://api.imagga.com/v2/uploads"
#     header = ["Authorization": "Basic YWNjX2I2ZDBlOTgzZTc0YzQ1NjpkOGE4NTYzY2NiNzJjMDAyN2IyOGNhYTY5YjU2MzA5OQ==", 'ContentType': "image/jpeg", 'Accept': "application/json"]
#     {:multipart, [{:image, "priv/static/images/2-IMG_6537.jpg", {"form-data", [{"name", "files[]"}, {"filename", Path.basename("priv/static/images/2-IMG_6537.jpg")}]}}]}
#     {:ok, bin} = File.read(image_path)
#     case HTTPoison.post(url, {"image": bin}, header) do
#       {:ok, %HTTPoison.Response{body: body} = response} ->
#         {:ok, %{"result" => %{"upload_id" => upload_id}}} = Jason.decode(body)
#         upload_id
#       {:error, reason} ->
#         reason
#     end
#   end

#   def generate_tags(image_path) do
#     upload_id = upload_image(image_path)
#     IO.puts "upload id"
#     IO.inspect upload_id
#     url = "https://api.imagga.com/v2/tags"
#     header = ["Authorization": "Basic YWNjX2I2ZDBlOTgzZTc0YzQ1NjpkOGE4NTYzY2NiNzJjMDAyN2IyOGNhYTY5YjU2MzA5OQ==", 'Accept': "application/json"]
#     params = %{"image_upload_id": upload_id}
#     case HTTPoison.get(url, header, params: params) do
#       {:ok, %HTTPoison.Response{body: body} = response} ->
#         # IO.inspect response
#         response
#       {:error, reason} ->
#         reason
#     end
#   end


end


# # curl --request GET \
# #   --url 'https://api.imagga.com/v2/tags?i18f09efcVFKznW' \
# #   --header 'accept: application/json' \
# #   --header 'authorization: Basic YWNjX2I2ZDBlOTgzZTc0YzQ1NjpkOGE4NTYzY2NiNzJjMDAyN2IyOGNhYTY5YjU2MzA5OQ=='


# schema "users" do
#   field :email, :string
#   field :name, :string
#   field :password_hash, :string
#   field :userid, :string
#   field :password, :string, virtual: true

#   timestamps()
# end

# @doc false
# def changeset(user, attrs) do
#   user
#   |> cast(attrs, [:name, :email, :password])
#   |> validate_required([:name, :email])
#   |> validate_length(:password, min: 8)
#   |> validate_format(:email, ~r/@/)
#   |> unique_constraint(:email)
#   |> encrypt_password
#   |> generate_userid
# end

# defp encrypt_password(changeset) do
#   password = get_change(changeset, :password)
#   if password do
#       encrypted_password = Encryption.hash_password(password)
#       put_change(changeset, :password_hash, encrypted_password)
#   else
#       changeset
#   end
# end

# defp generate_userid(changeset) do
#   userid = Encryption.random_string(64)
#   put_change(changeset, :userid, userid)
# end


# create table(:users) do
#   add :name, :string
#   add :username, :string, null: false 
#   add :password_hash, :string
  
#   timestamps()
# end