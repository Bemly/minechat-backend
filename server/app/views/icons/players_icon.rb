class Icons::PlayersIcon < Phlex::SVG
  def view_template
    svg(class: "card-icon", viewBox: "0 0 100 100") do
      # Steve (右侧)
      g(transform: "translate(15, -5)") do
        path(d: "M50 75 L75 60 L75 35 L50 50 L25 35 L25 60 Z", fill: "#b07e60", stroke: "#333", stroke_width: "2")
        path(d: "M50 75 L75 60 L50 50 Z", fill: "#906040", stroke: "#333", stroke_width: "2")
        path(d: "M50 20 L75 35 L50 50 L25 35 Z", fill: "#4a3018", stroke: "#333", stroke_width: "2")
        path(d: "M25 35 L50 50 L50 55 L25 40 Z", fill: "#4a3018")
      end
      # Alex (左侧)
      g(transform: "translate(-15, 15)") do
        path(d: "M50 75 L75 60 L75 35 L50 50 L25 35 L25 60 Z", fill: "#f0b590", stroke: "#333", stroke_width: "2")
        path(d: "M50 75 L75 60 L50 50 Z", fill: "#d09570", stroke: "#333", stroke_width: "2")
        path(d: "M50 20 L75 35 L50 50 L25 35 Z", fill: "#e07a20", stroke: "#333", stroke_width: "2")
        path(d: "M25 35 L50 50 L50 60 L25 45 Z", fill: "#e07a20")
      end
    end
  end
end
