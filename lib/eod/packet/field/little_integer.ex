defmodule EOD.Packet.Field.LittleInteger do
  @moduledoc """
  A little endian integer.  This requires the size to be at least two bytes.
  """
  use EOD.Packet.Field

  def struct_field_pair({name, opts}) do
    default = Keyword.get(opts, :default, 0)

    unless is_integer(default) do
      raise ArgumentError, "Little integer field :#{name} default must be an integer!"
    end

    {name, default}
  end

  def from_binary_match({name, opts}) do
    size = size_from_opts(name, opts)

    quote do
      unquote(Macro.var(name, nil)) :: little-integer-size(unquote(size))
    end
  end

  def from_binary_struct({name, _}) do
    quote do
      {unquote(name), unquote(Macro.var(name, nil))}
    end
  end

  def to_binary_match(pair), do: from_binary_struct(pair)

  def to_binary_bin(pair), do: from_binary_match(pair)

  def size({name, opts}), do: size_from_opts(name, opts)

  defp size_from_opts(name, opts) do
    case Keyword.get(opts, :size, nil) do
      nil ->
        raise ArgumentError, "Little integer field :#{name} requires a size."

      [bytes: 1] ->
        raise ArgumentError, "Little integer field :#{name} must be at least two bytes"

      [bytes: num] ->
        num * 8

      _ ->
        raise ArgumentError, "Little integer field :#{name} size must be in bytes"
    end
  end
end
