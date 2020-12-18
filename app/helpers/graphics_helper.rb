module GraphicsHelper
  def render_graphic(kpi)
    # pie_chart ({ indicador: kpi.indicator.values.last.valor * 100,
    #             "meta restante": (kpi.indicator.goals.last.valor * 100 - kpi.indicator.values.last.valor * 100) }),
    #             donut: true, download: true, legend: true, defer: true, colors: ['#045762', 'rgb(175, 12, 12)'], width: '250px', height: '250px'

    options_circle = { chart: { offsetX: -0, offsetY: -16, width: '100%', height: '90%' },
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
                           data_labels: { show: true, total: { show: false, label: kpi.indicator.sigla },
                                          name: { show: true },
                                          value: { show: true } }
                         }
                       } }

    options_line = { chart: { offsetX: -0, offsetY: -0, width: '100%', height: '70%' },
                     legend: { show: true, position: 'top', offsetY: 20 },
                     defer: true, colors: ['#045762', 'rgb(175, 12, 12)'] }

    if kpi.tipo_grafico == "circular"
      case kpi.indicator.valor_maximo
      when 1
        multiplicador = 100
      when 100
        multiplicador = 1
      when 1000
        multiplicador = 0.1
      else
        multiplicador = 1
      end
      return radial_bar_chart([
                                { name: "indicador", data: kpi.indicator.percent_meta[:valor] * multiplicador },
                                { name: "meta", data: kpi.indicator.percent_meta[:meta] * multiplicador }
                              ], options_circle)
    elsif kpi.tipo_grafico == "linha"
      ano_atual = Date.today.year
      x_array = kpi.indicator.param_graph(2, ano_atual - 2, ano_atual)
      return line_chart(x_array, options_line)

    elsif kpi.tipo_grafico == "barra"
      ano_atual = Date.today.year
      x_array = kpi.indicator.param_graph(2, ano_atual - 2, ano_atual)
      return column_chart(x_array, options_line)
    end
  end
end
