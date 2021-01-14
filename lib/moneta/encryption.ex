defmodule Moneta.Encryption do
    alias Moneta.Users.User
  
    def hash_password(password), do: Bcrypt.hash_pwd_salt(password)
  
    def validate_password(%User{} = user, password), do: Bcrypt.check_pass(user, password)

    def random_string(length) do
        :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
    end
    
  end