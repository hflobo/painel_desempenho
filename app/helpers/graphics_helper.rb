module GraphicsHelper
  def render_graphic(kpi)
    # pie_chart ({ indicador: kpi.indicator.values.last.valor * 100,
    #             "meta restante": (kpi.indicator.goals.last.valor * 100 - kpi.indicator.values.last.valor * 100) }),
    #             donut: true, download: true, legend: true, defer: true, colors: ['#045762', 'rgb(175, 12, 12)'], width: '250px', height: '250px'

    options = { chart: { offsetX: -35, offsetY: -20, width: 300, height: 350 },
                legend: { show: true, position: 'top', offsetY: 30 },
                defer: true, colors: ['#045762', 'rgb(175, 12, 12)'],
                plot_options: {
                  radial_bar: {
                    start_angle:-135,
                    end_angle: 135,
                    data_labels: { show: true, total: { show: false, label: kpi.indicator.sigla},
                      name: { show: true },
                      value: { show: true }
                    }
                  }
                }
              }

    radial_bar_chart([
      { name: "apurado", data: kpi.indicator.values.last.valor * 100 },
      { name: "meta", data: kpi.indicator.goals.last.valor * 100 }
      ], options
      )
  end
end
