defmodule MemoGenerator.MarkdownTest do
  use ExUnit.Case

  test "h1 functionality" do
    assert MemoGenerator.Markdown.h1("a") == "# a"
    assert MemoGenerator.Markdown.h1(1) == "# 1"
  end

  test "h2 functionality" do
    assert MemoGenerator.Markdown.h2("a") == "## a"
    assert MemoGenerator.Markdown.h2(1) == "## 1"
  end

  test "h3 functionality" do
    assert MemoGenerator.Markdown.h3("a") == "### a"
    assert MemoGenerator.Markdown.h3(1) == "### 1"
  end

  test "h4 functionality" do
    assert MemoGenerator.Markdown.h4("a") == "#### a"
    assert MemoGenerator.Markdown.h4(1) == "#### 1"
  end

  test "h5 functionality" do
    assert MemoGenerator.Markdown.h5("a") == "##### a"
    assert MemoGenerator.Markdown.h5(1) == "##### 1"
  end

  test "linebreak functionality" do
    assert MemoGenerator.Markdown.linebreak() == "---"
  end

  test "unorderd list functionality" do
    assert MemoGenerator.Markdown.list("a") == "* a"
    assert MemoGenerator.Markdown.list(1) == "* 1"
  end

  test "quote functionality" do
    assert MemoGenerator.Markdown.quote("a") == "> a"
    assert MemoGenerator.Markdown.quote(1) == "> 1"
  end

  test "break functionality" do
    assert MemoGenerator.Markdown.break(1) == "<br>"
    assert MemoGenerator.Markdown.break(4) == "<br><br><br><br>"
  end
end
