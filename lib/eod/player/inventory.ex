defmodule EOD.Player.Inventory do
  @moduledoc """
  This module manges the inventory of a player; which is everything the player
  is carrying, is equiped, and in their vault(s).
  """

  alias EOD.{Player, Repo}
  alias Repo.InventorySlot
  alias EOD.Packet.Server.InventoryUpdate
  alias InventoryUpdate.ItemData

  def init(%Player{} = player) do
    import Ecto.Query, only: [from: 2]
    inventory =
      from(s in InventorySlot, where: s.character_id == ^player.character.id)
      |> Repo.all

    {:ok, put_in(player.data[:inventory], inventory)}
  end

  defp inventory_slot_to_item_data(slot) do
    %ItemData{
      slot_number: slot.slot_position,
      dps_af: slot.dps || slot.af || 0,
      spd_ab: slot.speed || slot.abs || 0,
      damage_type: slot.damage_type || 0,
      weight: slot.weight || 0,
      condition_percent: slot.condition || 0,
      durability_percent: slot.durability || 0,
      quality_percent: slot.quality_percent || 0,
      bonus_percent: slot.bonus || 0,
      emblem_or_color: slot.emblem || slot.color || 0,
      model: slot.model || 0,
      extension: slot.extension || 0,
      byte_flag: slot.magic_flag || 0,
      effect: slot.effect || 0,
      name: String.slice(slot.name || "", 0, 54)
    }
  end
end
