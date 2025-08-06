defmodule Treap do
  @moduledoc """
  <https://cp-algorithms.com/data_structures/treap.html>
  This is max heap.
  """

  @type key :: any()
  @type priority :: any()

  defstruct [:key, :priority, left: nil, right: nil]
  @type t :: %__MODULE__{key: key(), priority: priority(), left: t() | nil, right: t() | nil}

  @spec split(t() | nil, key()) :: {t() | nil, t() | nil}
  defp split(%Treap{key: key, right: right} = node, x) when key <= x do
    {l, r} = split(right, x)
    {%{node | right: l}, r}
  end

  defp split(%Treap{left: left} = node, x) do
    {l, r} = split(left, x)
    {l, %{node | left: r}}
  end

  defp split(nil, _), do: {nil, nil}

  @spec merge(t() | nil, t() | nil) :: t() | nil
  defp merge(%Treap{priority: lp, right: r} = left, %Treap{priority: rp} = right) when lp >= rp,
    do: %{left | right: merge(r, right)}

  defp merge(%Treap{} = left, %Treap{left: l} = right), do: %{right | left: merge(left, l)}

  defp merge(%Treap{} = left, nil), do: left
  defp merge(nil, %Treap{} = right), do: right
  defp merge(nil, nil), do: nil

  @spec insert(t() | nil, key(), priority()) :: t()
  def insert(%Treap{key: nkey, priority: npriority} = node, key, priority)
      when key == nkey and priority == npriority,
      do: node

  def insert(%Treap{priority: npriority} = node, key, priority) when npriority < priority do
    {l, r} = split(node, key)
    %Treap{key: key, priority: priority, left: l, right: r}
  end

  def insert(%Treap{key: nkey, left: left} = node, key, priority) when key <= nkey,
    do: %{node | left: insert(left, key, priority)}

  def insert(%Treap{right: right} = node, key, priority),
    do: %{node | right: insert(right, key, priority)}

  def insert(nil, key, priority), do: %Treap{key: key, priority: priority}

  @spec delete(t() | nil, key()) :: t() | nil
  def delete(%Treap{key: nkey, left: left, right: right}, key) when key == nkey,
    do: merge(left, right)

  def delete(%Treap{key: nkey, left: left} = node, key) when key < nkey,
    do: %{node | left: delete(left, key)}

  def delete(%Treap{right: right} = node, key), do: %{node | right: delete(right, key)}

  def delete(nil, _), do: nil

  @spec member?(t() | nil, key()) :: {:ok, priority()} | nil
  def member?(%Treap{key: nkey, priority: priority}, key) when nkey == key, do: {:ok, priority}
  def member?(%Treap{key: nkey, left: left}, key) when key < nkey, do: member?(left, key)
  def member?(%Treap{left: right}, key), do: member?(right, key)

  def member?(nil, _), do: nil

  @spec manyinsert(t() | nil, [{key(), priority()}]) :: t() | nil
  def manyinsert(node, kp) do
    for {k, p} <- kp, reduce: node do
      node -> insert(node, k, p)
    end
  end
end
