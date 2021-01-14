defmodule Moneta.Auth do
    alias Moneta.{Encryption, Users}

    def login(params) do
        user = Users.get_user!(params["email"])
        case authenticate(user, params["password"]) do
            true -> {:ok, user}
            _    -> :error
        end
    end

    def authenticate(user, password) do
        if user do
            authenticated_user = 
            case Encryption.validate_password(user, password) do
                {:ok, validated_user} -> validated_user.email == user.email
                {:error, _} -> false
            end
         else
             nil
         end
    end

    def signed_in?(conn) do
        case conn.private.plug_session["current_user_id"] do
            nil ->
                false
            _ ->
                true
        end
    end

end