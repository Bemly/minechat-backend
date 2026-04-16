class Icons::TerrainIcon < Phlex::SVG
  def view_template
    svg(class: "card-icon", viewBox: "0 0 100 100") do
      # 底部泥土基座
      path(d: "M50 85 L85 65 L85 40 L50 60 L15 40 L15 65 Z", fill: "#79553a", stroke: "#4a3322", stroke_width: "2")
      path(d: "M50 85 L85 65 L50 60 Z", fill: "#60422c", stroke: "#4a3322", stroke_width: "2")
      # 顶层草地
      path(d: "M50 20 L85 40 L50 60 L15 40 Z", fill: "#5c9a3b", stroke: "#3b6b21", stroke_width: "2")
      path(d: "M15 40 L50 60 L50 65 L15 45 Z", fill: "#4d8230")
      path(d: "M85 40 L50 60 L50 65 L85 45 Z", fill: "#3b6b21")
      # 高地石块
      path(d: "M35 15 L55 25 L35 35 L15 25 Z", fill: "#e0e0e0", stroke: "#999", stroke_width: "1")
      path(d: "M15 25 L35 35 L35 50 L15 40 Z", fill: "#a0a0a0", stroke: "#777", stroke_width: "1")
      path(d: "M55 25 L35 35 L35 50 L55 40 Z", fill: "#c0c0c0", stroke: "#777", stroke_width: "1")
      # 树木
      rect(x: "70", y: "30", width: "4", height: "10", fill: "#5c4033")
      path(d: "M65 25 L77 25 L77 35 L65 35 Z", fill: "#2d5a1e")
    end
  end
end
