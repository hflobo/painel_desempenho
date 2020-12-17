module GraphicsHelper
  def render_graphic(kpi)
    # pie_chart ({ indicador: kpi.indicator.values.last.valor * 100,
    #             "meta restante": (kpi.indicator.goals.last.valor * 100 - kpi.indicator.values.last.valor * 100) }),
    #             donut: true, download: true, legend: true, defer: true, colors: ['#045762', 'rgb(175, 12, 12)'], width: '250px', height: '250px'

    options_circle = { chart: { offsetX: -0, offsetY: -0, width: '100%', height: '100%' },
                legend: { show: true, position: 'top', offsetY: 20 },
                defer: true, colors: ['#045762', 'rgb(175, 12, 12)'],
                plot_options: {
                  radial_bar: {
                    start_angle: -135,
                    end_angle: 135,
                    hollow: {
                      margin: 2,
                      size: '40%'
                    },
                    data_labels: { show: true, total: { show: false, label: kpi.indicator.sigla},
                      name: { show: true },
                      value: { show: true }
                    }
                  }
                } }

    options_line = { chart: { offsetX: -0, offsetY: -0, width: '100%', height: '100%' },
                legend: { show: true, position: 'top', offsetY: 20 },
                defer: true, colors: ['#045762', 'rgb(175, 12, 12)'],
              }

    if kpi.tipo_grafico == "circular"
      return radial_bar_chart([
        { name: "apurado", data: kpi.indicator.values.last.valor * 100 },
        { name: "meta", data: kpi.indicator.goals.last.valor * 100 }
        ], options_circle
        )
    elsif kpi.tipo_grafico == "linha"
      return line_chart(kpi.indicator.param_graph(true,2017,2020), options_line)

    elsif kpi.tipo_grafico == "barra"
      return column_chart(kpi.indicator.param_graph(true,2017,2020), options_line)
    end

  end
end
