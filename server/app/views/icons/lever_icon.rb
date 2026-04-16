class Icons::LeverIcon < Phlex::SVG
  def view_template
    svg(class: "card-icon", viewBox: "0 0 100 100") do
      # 石质底座1
      path(d: "M30 70 L50 60 L50 45 L30 55 Z", fill: "#888", stroke: "#333", stroke_width: "2")
      path(d: "M30 55 L50 45 L40 40 L20 50 Z", fill: "#aaa", stroke: "#333", stroke_width: "2")
      path(d: "M50 70 L70 60 L70 45 L50 55 Z", fill: "#666", stroke: "#333", stroke_width: "2")
      path(d: "M50 55 L70 45 L60 40 L40 50 Z", fill: "#aaa", stroke: "#333", stroke_width: "2")
      # 拉杆柄
      path(d: "M45 45 L70 20 L75 25 L50 50 Z", fill: "#a05a2c", stroke: "#333", stroke_width: "2")
      # 红石粉点缀
      circle(cx: "45", cy: "60", r: "3", fill: "#ff0000")
      circle(cx: "55", cy: "55", r: "2", fill: "#ff0000")
      # + 符号
      text(x: "30", y: "75") { "+" }
    end
  end
end
