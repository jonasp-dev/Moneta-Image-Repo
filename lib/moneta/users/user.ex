defmodule Moneta.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Moneta.{Encryption}
  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :userid, :string
    field :password, :string, virtual: true
    has_many :images, Moneta.Image
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> encrypt_password
    |> generate_userid
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)
    if password do
        encrypted_password = Encryption.hash_password(password)
        put_change(changeset, :password_hash, encrypted_password)
    else
        changeset
    end
  end
  
  defp generate_userid(changeset) do
    userid = Encryption.random_string(64)
    put_change(changeset, :userid, userid)
  end
end


