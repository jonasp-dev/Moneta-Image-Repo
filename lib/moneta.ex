defmodule Moneta do
  alias Moneta.{Image, Repo}
 
  def create_upload_from_plug_upload(%Plug.Upload{
    filename: filename,
    path: tmp_path,
    content_type: content_type,
  }, user) do
    IO.inspect user
    hash =
      File.stream!(tmp_path, [], 2048)
      |> Image.sha256()
    
    Repo.transaction fn ->
      with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
      {:ok, image} <- 
        %Image{} |> Image.changeset(user, %{
          filename: filename, content_type: content_type,
          hash: hash, size: size}) 
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


end

