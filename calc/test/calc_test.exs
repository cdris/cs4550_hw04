defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "simple operators" do
    assert Calc.eval("2+2") == 4.0
    assert Calc.eval("5*2") == 10.0
    assert Calc.eval("6/3") == 2.0
    assert Calc.eval("10/4") == 2.5
    assert Calc.eval("8-5") == 3.0
  end

  test "no parenthesis" do
    assert Calc.eval("1 + 3 * 3 + 1") == 11.0
    assert Calc.eval("21 / 3 - 2") == 5.0
    assert Calc.eval("10 / 2 * 4 / 0.5") == 40.0
    assert Calc.eval("10 - 2 + 4 - 5") == 7.0
  end

  test "basic parenthesis" do
    assert Calc.eval("24 / 6 + (5 - 4)") == 5.0
    assert Calc.eval("10 / (1 + 1) * 8 / (5 / 2)") == 16.0
  end

  test "nested parenthesis" do
    assert Calc.eval("24 / 6 + (5 - (4 / 2))") == 7.0
    assert Calc.eval("10 * 3 / (5 - (3 * 2) + 5 / (8 / 2)) - 1") == 119.0
  end

  test "invalid syntax" do
    assert_raise RuntimeError, fn ->
      Calc.eval("+")
    end
    assert_raise RuntimeError, fn ->
      Calc.eval("- +")
    end
    assert_raise RuntimeError, fn ->
      Calc.eval("2 +")
    end
    assert_raise RuntimeError, fn ->
      Calc.eval("/ 2")
    end
    assert_raise RuntimeError, fn ->
      Calc.eval("()")
    end
    assert_raise RuntimeError, fn ->
      Calc.eval("( 1 + 4")
    end
    assert_raise RuntimeError, fn ->
      Calc.eval("3 - 4 )")
    end
  end

  test "eval_num helper" do
    assert Calc.eval_num(10, []) == [10]
    assert Calc.eval_num(4, ["*", 3]) == [12]
    assert Calc.eval_num(2, ["/", 10]) == [5]
    assert Calc.eval_num(19, ["+", 4]) == [19, "+", 4]
    assert Calc.eval_num(3, ["-", 8]) == [3, "-", 8]
    assert Calc.eval_num(10, [3]) == [10, 3]
  end

  test "eval_stack helper" do
    assert Calc.eval_stack([1], false) == [1]
    assert_raise RuntimeError, fn ->
      Calc.eval_stack([1], true)
    end
    assert Calc.eval_stack([2, "("], false) == [2, "("]
    assert Calc.eval_stack([4, "("], true) == [4]
    assert Calc.eval_stack([1, "+", 4], false) == [5]
    assert Calc.eval_stack([1, "+", 4, "("], false) == [5, "("]
    assert Calc.eval_stack([1, "+", 4, "("], true) == [5]
    assert_raise RuntimeError, fn ->
      Calc.eval_stack([1, "+", 4], true)
    end
    assert Calc.eval_stack([6, "-", 9, "("], true) == [3]
    assert Calc.eval_stack([6, "-", 9], false) == [3]
    assert Calc.eval_stack([6, "-", 9, "("], false) == [3, "("]
    assert_raise RuntimeError, fn ->
      Calc.eval_stack([6, "-", 9], true)
    end
  end
end
