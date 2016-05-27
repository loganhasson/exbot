defmodule Exbot.Slack do
  use Slack
  require IEx

  @token Application.get_env(:exbot, __MODULE__)[:token]
  @uid "U1C54BE7M"
  @general_id "C1C6JSERM"
  @username "exbot"

  def start_link, do: start_link(@token, [])

  def handle_message(%{channel: "D" <> id = dm_id, user: user, type: "message"} = message, slack, state) do
    send_message("What can't be said in public?", message.channel, slack)
    {:ok, state}
  end
  def handle_message(%{type: "message", text: "<@#{@uid}>" <> msg = msg_text, user: user} = message, slack, state) do
    send_message("<@#{user}>: Shh, leave me alone!", message.channel, slack)
    {:ok, state}
  end
  def handle_message(%{type: "channel_joined"} = message, slack, state) do
    send_message("It's party time!", message.channel, slack)
    {:ok, state}
  end
  def handle_message(%{subtype: "channel_join", user_profile: %{name: @username}} = message, slack, state) do
    send_message("It's party time!", message.channel, slack)
    {:ok, state}
  end
  def handle_message(%{type: "presence_change", user: user, presence: presence} = message, slack, state) do
    if user != @uid do
      presence
      |> presence_message(user)
      |> send_message(@general_id, slack)
    end

    {:ok, state}
  end
  def handle_message(_message, _slack, state), do: {:ok, state}

  defp presence_message(presence, user) do
    case presence do
      "away" ->
        "See you later, <@#{user}>!"
      "active" ->
        "Hello, <@#{user}>!"
    end
  end
end
