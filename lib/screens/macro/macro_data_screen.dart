import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme.dart';

class _DataLink {
  final String title;
  final String url;
  final String description;
  final IconData icon;
  final Color color;

  const _DataLink({
    required this.title,
    required this.url,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class MacroDataScreen extends StatelessWidget {
  const MacroDataScreen({super.key});

  static const _usLinks = [
    _DataLink(
      title: 'FISCAL DATA · Tesoro EE.UU.',
      url: 'https://fiscaldata.treasury.gov/americas-finance-guide/',
      description: 'Deuda nacional, deficit, ingresos y gastos del gobierno federal',
      icon: Icons.account_balance,
      color: AppTheme.gold,
    ),
    _DataLink(
      title: 'TRADING ECONOMICS · CALENDARIO',
      url: 'https://tradingeconomics.com/calendar',
      description: 'Calendario economico global con impacto y forecasts',
      icon: Icons.event,
      color: AppTheme.violet,
    ),
    _DataLink(
      title: 'INVESTOPEDIA · EDUCACION',
      url: 'https://www.investopedia.com/',
      description: 'Enciclopedia financiera: conceptos, mercados, estrategias',
      icon: Icons.menu_book,
      color: AppTheme.goldBright,
    ),
    _DataLink(
      title: 'FOMC · DOT PLOT',
      url: 'https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm',
      description: 'Reuniones FOMC + proyecciones de tasas (dot plot)',
      icon: Icons.scatter_plot,
      color: AppTheme.danger,
    ),
    _DataLink(
      title: 'ISM · PMI MANUFACTURERO',
      url: 'https://www.ismworld.org/supply-management-news-and-reports/reports/ism-pmi-on-manufacturing/',
      description: 'PMI >50 expansion, <50 contraccion. Leading indicator',
      icon: Icons.factory,
      color: AppTheme.warning,
    ),
    _DataLink(
      title: 'BLS · EMPLEO E INFLACION EE.UU.',
      url: 'https://www.bls.gov/',
      description: 'NFP, Unemployment Rate, CPI, PPI, wage growth',
      icon: Icons.work,
      color: AppTheme.success,
    ),
    _DataLink(
      title: 'FRED · ST. LOUIS FED DATA',
      url: 'https://fred.stlouisfed.org/',
      description: 'Base de datos macro de la Fed: GDP, PCE, M2, yields',
      icon: Icons.bar_chart,
      color: AppTheme.violet,
    ),
  ];

  static const _euLinks = [
    _DataLink(
      title: 'ECB · BANCO CENTRAL EUROPEO',
      url: 'https://www.ecb.europa.eu/',
      description: 'Politica monetaria, tipos de interes, programa de compras APP',
      icon: Icons.euro,
      color: AppTheme.gold,
    ),
    _DataLink(
      title: 'ECB · DECISIONES DE TIPOS',
      url: 'https://www.ecb.europa.eu/mopo/decisions/html/index.en.html',
      description: 'Historial de decisiones de tipos y comunicados oficiales',
      icon: Icons.gavel,
      color: AppTheme.warning,
    ),
    _DataLink(
      title: 'EUROSTAT · DATA EUROPA',
      url: 'https://ec.europa.eu/eurostat',
      description: 'IPC, PIB, desempleo, deuda soberana zona euro',
      icon: Icons.public,
      color: AppTheme.violet,
    ),
  ];

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      // Primer intento: app externa
      var ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      // Fallback: dejar que el sistema elija
      if (!ok) {
        ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
      if (!ok && context.mounted) {
        _toast(context, 'No se pudo abrir: $url');
      }
    } catch (e) {
      if (context.mounted) {
        _toast(context, 'Error: ${e.toString().substring(0, 60)}');
      }
    }
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, maxLines: 3, overflow: TextOverflow.ellipsis),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          _sectionHeader('🇺🇸  ESTADOS UNIDOS'),
          const SizedBox(height: 4),
          ..._usLinks.map((l) => _linkTile(context, l)),
          const SizedBox(height: 16),
          _sectionHeader('🇪🇺  EUROPA'),
          const SizedBox(height: 4),
          ..._euLinks.map((l) => _linkTile(context, l)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.gold, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Los enlaces se abren en el navegador del sistema. Volvé a TNSVT con el botón Back.',
                    style: TextStyle(
                      fontFamily: AppTheme.labelFont,
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      letterSpacing: 0.5,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTheme.displayFont,
          color: AppTheme.goldBright,
          fontSize: 13,
          letterSpacing: 3,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _linkTile(BuildContext context, _DataLink l) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(left: BorderSide(color: l.color, width: 3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => _open(context, l.url),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(l.icon, color: l.color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.title,
                        style: TextStyle(
                          fontFamily: AppTheme.labelFont,
                          color: AppTheme.goldBright,
                          fontSize: 11,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.description,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.url,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: l.color.withOpacity(0.7),
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.open_in_new, color: l.color.withOpacity(0.6), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
