defmodule Rumbl.WatchController do
  use Rumbl.Web, :controller
  alias Rumbl.Video

  #defaulf action - uses conn.assigns.current_user on every action
  #this controller
  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
        [conn, conn.params, conn.assigns.current_user])
  end

  def show(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video, %{ view_count: video.view_count + 1})
    case Repo.update(changeset) do
        {:ok, video} ->
          render conn, "show.html", video: video
        {:error, video} ->
          conn
          |> put_flash(:error, "Error uptading view_count.")
          |> render(conn, "show.html", video: video)
    end

  end

  defp user_videos(user) do
    assoc(user, :videos)
  end

end
