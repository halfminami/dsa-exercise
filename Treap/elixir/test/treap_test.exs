defmodule TreapTest do
  use ExUnit.Case
  doctest Treap

  test "insert into nil" do
    assert Treap.insert(nil, 12, 8) == %Treap{key: 12, priority: 8, left: nil, right: nil}
  end

  test "insert into tree 1" do
    assert Treap.insert(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 1}
             },
             12,
             8
           ) == %Treap{
             key: 12,
             priority: 9,
             left: %Treap{
               key: 8,
               priority: 8,
               right: %Treap{key: 12, priority: 8, left: %Treap{key: 9, priority: 7}}
             },
             right: %Treap{key: 13, priority: 1}
           }
  end

  test "insert into tree 2" do
    assert Treap.insert(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 1}
             },
             12,
             7
           ) == %Treap{
             key: 12,
             priority: 9,
             left: %Treap{
               key: 8,
               priority: 8,
               right: %Treap{key: 9, priority: 7, right: %Treap{key: 12, priority: 7}}
             },
             right: %Treap{key: 13, priority: 1}
           }
  end

  test "insert into tree 3" do
    assert Treap.insert(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 1}
             },
             13,
             7
           ) == %Treap{
             key: 12,
             priority: 9,
             left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
             right: %Treap{key: 13, priority: 7, left: %Treap{key: 13, priority: 1}}
           }
  end

  test "insert into tree 4" do
    assert Treap.insert(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 1}
             },
             12,
             10
           ) == %Treap{
             key: 12,
             priority: 10,
             left: %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}}
             },
             right: %Treap{key: 13, priority: 1}
           }
  end

  test "insert into tree 5" do
    assert Treap.insert(
             %Treap{
               key: 12,
               priority: 10,
               left: %Treap{
                 key: 8,
                 priority: 8,
                 left: %Treap{
                   key: 7,
                   priority: 7,
                   left: %Treap{key: 3, priority: 7},
                   right: %Treap{key: 8, priority: 3}
                 },
                 right: %Treap{
                   key: 11,
                   priority: 8,
                   left: %Treap{key: 8, priority: 8, right: %Treap{key: 10, priority: 5}},
                   right: %Treap{key: 12, priority: 7, left: %Treap{key: 11, priority: 6}}
                 }
               },
               right: %Treap{key: 14, priority: 10}
             },
             10,
             9
           ) ==
             %Treap{
               key: 12,
               priority: 10,
               left: %Treap{
                 key: 10,
                 priority: 9,
                 left: %Treap{
                   key: 8,
                   priority: 8,
                   left: %Treap{
                     key: 7,
                     priority: 7,
                     left: %Treap{key: 3, priority: 7},
                     right: %Treap{key: 8, priority: 3}
                   },
                   right: %Treap{
                     key: 8,
                     priority: 8,
                     right: %Treap{key: 10, priority: 5}
                   }
                 },
                 right: %Treap{
                   key: 11,
                   priority: 8,
                   right: %Treap{key: 12, priority: 7, left: %Treap{key: 11, priority: 6}}
                 }
               },
               right: %Treap{key: 14, priority: 10}
             }
  end

  test "insert doesn't allow duplicates" do
    assert Treap.insert(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 1}
             },
             8,
             8
           ) == %Treap{
             key: 12,
             priority: 9,
             left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
             right: %Treap{key: 13, priority: 1}
           }
  end

  test "delete from nil" do
    assert Treap.delete(nil, 12) == nil
  end

  test "delete from tree 1" do
    assert Treap.delete(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 1}
             },
             12
           ) == %Treap{
             key: 8,
             priority: 8,
             right: %Treap{key: 9, priority: 7, right: %Treap{key: 13, priority: 1}}
           }
  end

  test "delete from tree 2" do
    assert Treap.delete(
             %Treap{
               key: 12,
               priority: 9,
               left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}},
               right: %Treap{key: 13, priority: 9}
             },
             12
           ) == %Treap{
             key: 13,
             priority: 9,
             left: %Treap{key: 8, priority: 8, right: %Treap{key: 9, priority: 7}}
           }
  end

  test "delete from tree 3" do
    assert Treap.delete(
             %Treap{
               key: 20,
               priority: 12,
               left: %Treap{
                 key: 10,
                 priority: 10,
                 left: %Treap{
                   key: 8,
                   priority: 9,
                   right: %Treap{key: 10, priority: 1}
                 },
                 right: %Treap{
                   key: 11,
                   priority: 10,
                   left: %Treap{key: 11, priority: 3}
                 }
               }
             },
             10
           ) == %Treap{
             key: 20,
             priority: 12,
             left: %Treap{
               key: 11,
               priority: 10,
               left: %Treap{
                 key: 8,
                 priority: 9,
                 right: %Treap{key: 11, priority: 3, left: %Treap{key: 10, priority: 1}}
               }
             }
           }
  end
end
