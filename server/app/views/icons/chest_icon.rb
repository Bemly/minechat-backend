class Icons::ChestIcon < Phlex::SVG
  def view_template
    svg(class: "card-icon", viewBox: "0 0 100 100") do
      # 箱体侧面/前面
      path(d: "M50 85 L85 65 L85 35 L50 55 L15 35 L15 65 Z", fill: "#a06030", stroke: "#301505", stroke_width: "3")
      path(d: "M50 85 L85 65 L50 55 Z", fill: "#7a4520", stroke: "#301505", stroke_width: "3")
      # 箱子顶部
      path(d: "M50 15 L85 35 L50 55 L15 35 Z", fill: "#c47a3f", stroke: "#301505", stroke_width: "3")
      # 黑色镶边与锁扣
      path(d: "M15 40 L50 60 L85 40", fill: "none", stroke: "#222", stroke_width: "4")
      rect(x: "46", y: "52", width: "8", height: "12", fill: "#c0c0c0", stroke: "#333", stroke_width: "2")
      # + 符号
      text(x: "30", y: "75") { "+" }
    end
  end
end
