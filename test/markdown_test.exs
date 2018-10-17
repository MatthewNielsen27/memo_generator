defmodule MemoGenerator.MarkdownTest do
  use ExUnit.Case

  alias MemoGenerator.Markdown

  test "h1 functionality" do
    assert Markdown.h1("a") == "# a"
    assert Markdown.h1(1) == "# 1"
  end

  test "h2 functionality" do
    assert Markdown.h2("a") == "## a"
    assert Markdown.h2(1) == "## 1"
  end

  test "h3 functionality" do
    assert Markdown.h3("a") == "### a"
    assert Markdown.h3(1) == "### 1"
  end

  test "h4 functionality" do
    assert Markdown.h4("a") == "#### a"
    assert Markdown.h4(1) == "#### 1"
  end

  test "h5 functionality" do
    assert Markdown.h5("a") == "##### a"
    assert Markdown.h5(1) == "##### 1"
  end

  test "linebreak functionality" do
    assert Markdown.linebreak() == "---"
  end

  test "unorderd list functionality" do
    assert Markdown.list("a") == "* a"
    assert Markdown.list(1) == "* 1"
  end

  test "quote functionality" do
    assert Markdown.quote("a") == "> a"
    assert Markdown.quote(1) == "> 1"
  end

  test "break functionality" do
    assert Markdown.break(1) == "<br>"
    assert Markdown.break(4) == "<br><br><br><br>"
  end
end
