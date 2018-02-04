defmodule Calc do

  def main do
    expr = String.trim(IO.gets("> "))
    try do
      IO.puts(eval(expr))
    rescue
      e in RuntimeError -> IO.puts(e.message)
      e in ArithmeticError -> IO.puts(e.message)
    end
    main()
  end

  def eval(expr) do
    eval(expr, [])
  end

  def eval(expr, stack) do
    if Regex.match?(~r/^\s*$/, expr) do
      case eval_stack(stack, false) do
        [result] -> result
        _ -> raise "Invalid Expression"
      end
    else
      [op, num, rest] = Regex.run(~r/(?:([^\d,\s])|(\d+(?:\.\d+)?))(.*)/,
                                  expr, capture: :all_but_first)
      cond do
        num != "" ->
          {num, _} = Float.parse(num)
          eval(rest, eval_num(num, stack))
        op == ")" ->
          eval(rest, eval_stack(stack, true))
        op == "(" or op == "*" or op == "/" ->
          eval(rest, [op | stack])
        op == "+" or op == "-" ->
          eval(rest, [op | eval_stack(stack, false)])
        true -> raise "Invalid Expression"
      end
    end
  end

  def eval_num(num, stack) do
    case stack do
      ["*", num1 | rest] -> [num1 * num | rest]
      ["/", num1 | rest] -> [num1 / num | rest]
      _ -> [num | stack]
    end
  end

  def eval_stack(stack, parens) do
    case {stack, parens} do
      {[_], false} -> stack
      {[_, "(" | _], false} -> stack
      {[num, "(" | rest], true} -> eval_num(num, rest)
      {[num2, "+", num1 | rest], p} -> eval_stack([num1 + num2 | rest], p)
      {[num2, "-", num1 | rest], p} -> eval_stack([num1 - num2 | rest], p)
      _ -> raise "Invalid Expression"
    end
  end

end
