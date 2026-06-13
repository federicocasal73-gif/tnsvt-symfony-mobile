class MacroQuestion {
  final String id;
  final String question;
  final List<MacroOption> options;
  final int correctIndex;
  final String explanation;

  const MacroQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class MacroOption {
  final String letter;
  final String text;
  const MacroOption({required this.letter, required this.text});
}

class MacroFlowNode {
  final String id;
  final String label;
  final String emoji;
  final String text;
  const MacroFlowNode({
    required this.id,
    required this.label,
    required this.emoji,
    required this.text,
  });
}

class MacroCyclePhase {
  final String title;
  final String emoji;
  final String description;
  const MacroCyclePhase({
    required this.title,
    required this.emoji,
    required this.description,
  });
}

class MacroInlineQuiz {
  final String id;
  final String question;
  final List<MacroOption> options;
  final String correctLetter;
  final String explanation;
  const MacroInlineQuiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctLetter,
    required this.explanation,
  });
}

class MacroConcept {
  final String id;
  final String title;
  final String emoji;
  final String summary;
  final List<MacroInlineQuiz> inlineQuizzes;
  const MacroConcept({
    required this.id,
    required this.title,
    required this.emoji,
    required this.summary,
    this.inlineQuizzes = const [],
  });
}

class MacroContent {
  static const List<MacroFlowNode> flowNodes = [
    MacroFlowNode(
      id: 'fed',
      label: 'Banco Central (FED)',
      emoji: '🏛',
      text: 'El principal market maker del mercado Forex. Su función es inyectar liquidez o encarecer el crédito.',
    ),
    MacroFlowNode(
      id: 'bonos',
      label: 'Compra de Bonos',
      emoji: '📜',
      text: 'El Estado emite un bono al Banco Central. Así se financia y se inyecta liquidez.',
    ),
    MacroFlowNode(
      id: 'tasas',
      label: 'Tasas de Interés',
      emoji: '📈',
      text: 'El precio del dinero. Tasas bajas → economía se calienta, Dólar débil. Tasas altas → economía se enfría, Dólar fuerte.',
    ),
    MacroFlowNode(
      id: 'ciudadanos',
      label: 'Economía Real',
      emoji: '👥',
      text: 'El destinatario final de la política monetaria. Crédito barato estimula consumo e inversión.',
    ),
  ];

  static const List<MacroCyclePhase> cyclePhases = [
    MacroCyclePhase(
      title: 'Recesión',
      emoji: '📉',
      description: 'Dos trimestres de PIB negativo o más. Desempleo sube, consumo cae, los Bancos Centrales bajan tasas para estimular. El mercado anticipa la recuperación antes de que llegue.',
    ),
    MacroCyclePhase(
      title: 'Recuperación',
      emoji: '🌱',
      description: 'Las tasas bajas empiezan a hacer efecto. El crédito fluye, la inversión vuelve, el empleo mejora. Los activos de riesgo (commodities, emergentes) lideran el repunte.',
    ),
    MacroCyclePhase(
      title: 'Expansión',
      emoji: '🚀',
      description: 'Economía a pleno rendimiento. Baja desempleo, inflación contenida, beneficios empresariales en máximos. El Banco Central empieza a subir tasas gradualmente para evitar el sobrecalentamiento.',
    ),
    MacroCyclePhase(
      title: 'Stagflación',
      emoji: '🔥',
      description: 'El peor escenario: economía estancada + inflación alta. Dilema imposible para el Banco Central: si sube tasas mata la economía, si las baja acelera la inflación. Suele requerir shocks externos (guerras, crisis energéticas).',
    ),
  ];

  static const List<MacroQuestion> quiz = [
    MacroQuestion(
      id: 'q1',
      question: '¿Quiénes son los actores más poderosos para mover el valor de una divisa?',
      options: [
        MacroOption(letter: 'A', text: 'Hedge Funds como Bridgewater o Renaissance'),
        MacroOption(letter: 'B', text: 'Los Bancos Centrales'),
        MacroOption(letter: 'C', text: 'BlackRock, JP Morgan y grandes fondos de inversión'),
        MacroOption(letter: 'D', text: 'Los traders retail actuando en conjunto'),
      ],
      correctIndex: 1,
      explanation: 'Los Bancos Centrales son los únicos actores que pueden influir directamente en el valor de una divisa.',
    ),
    MacroQuestion(
      id: 'q2',
      question: 'Sale un NFP fuerte (empleos suben) pero el Dólar cae. ¿Por qué?',
      options: [
        MacroOption(letter: 'A', text: 'Fue un error temporal del mercado que se va a corregir'),
        MacroOption(letter: 'B', text: 'El CPI salió mal el mismo día y opacó al NFP'),
        MacroOption(letter: 'C', text: 'Los salarios por hora (Average Hourly Earnings) bajaron: sin presión inflacionaria'),
        MacroOption(letter: 'D', text: 'La FED subió tasas inesperadamente ese mismo día'),
      ],
      correctIndex: 2,
      explanation: 'Si los empleos suben pero los salarios bajan, no hay presión inflacionaria → Dólar cae.',
    ),
    MacroQuestion(
      id: 'q3',
      question: 'Salen las Expectativas de Inflación. ¿En qué capítulo del protocolo operás?',
      options: [
        MacroOption(letter: 'A', text: 'Capítulo 1 (La Expectativa): esperando PMIs'),
        MacroOption(letter: 'B', text: 'Capítulo 2 (El Detonante): preparándome para el NFP'),
        MacroOption(letter: 'C', text: 'Capítulo 3 (La Tendencia): zona del CPI/inflación'),
        MacroOption(letter: 'D', text: 'Capítulo 4 (El Juicio Final): esperando FOMC'),
      ],
      correctIndex: 2,
      explanation: 'El CPI sale entre los días 10-15 del mes: Capítulo 3 (La Tendencia).',
    ),
    MacroQuestion(
      id: 'q4',
      question: 'El Dot Plot promete recortes de tasas. ¿Qué hace el Dólar?',
      options: [
        MacroOption(letter: 'A', text: 'Sube: las tasas no bajaron hoy, el dólar sigue siendo atractivo'),
        MacroOption(letter: 'B', text: 'Baja: el mercado anticipa recortes futuros y empieza a vender dólares ahora'),
        MacroOption(letter: 'C', text: 'Queda lateral: esperará a que se concreten los recortes'),
        MacroOption(letter: 'D', text: 'Sube y baja erráticamente sin dirección clara'),
      ],
      correctIndex: 1,
      explanation: 'El mercado anticipa el futuro. Si el Dot Plot promete recortes, se vende Dólar HOY.',
    ),
    MacroQuestion(
      id: 'q5',
      question: 'Headline CPI cae, pero Core CPI sube. ¿Reacción de la FED?',
      options: [
        MacroOption(letter: 'A', text: 'Bajará tasas: el Headline CPI cayó, la inflación está controlada'),
        MacroOption(letter: 'B', text: 'Se mantendrá agresiva (hawkish): el Core muestra inflación subyacente aún viva'),
        MacroOption(letter: 'C', text: 'Ignorará los datos y seguirá el cronograma planeado'),
        MacroOption(letter: 'D', text: 'Bajará tasas para estimular la economía ante la caída del Headline'),
      ],
      correctIndex: 1,
      explanation: 'El Core CPI es el dato "puro". Si sube, inflación subyacente viva → FED agresiva → Dólar fuerte.',
    ),
    MacroQuestion(
      id: 'q6',
      question: '¿Cómo operás los primeros 5 minutos después del NFP?',
      options: [
        MacroOption(letter: 'A', text: 'Entrás inmediatamente cuando salga el número en la dirección del dato'),
        MacroOption(letter: 'B', text: 'Ponés una orden pendiente buy stop y sell stop para capturar el movimiento'),
        MacroOption(letter: 'C', text: 'Manos fuera del ratón, cancelás órdenes pendientes y esperás mínimo hasta las 8:45'),
        MacroOption(letter: 'D', text: 'Abrís posiciones en ambas direcciones para cubrir cualquier movimiento'),
      ],
      correctIndex: 2,
      explanation: 'El NFP barre ambos lados. Esperar a que el caos se asiente es el protocolo correcto.',
    ),
    MacroQuestion(
      id: 'q7',
      question: 'Conflicto militar en Europa. ¿Qué pasa con los pares?',
      options: [
        MacroOption(letter: 'A', text: 'EUR/USD sube: Europa muestra fortaleza ante el conflicto'),
        MacroOption(letter: 'B', text: 'AUD/NZD sube: los pares de Oceanía son refugio en conflictos europeos'),
        MacroOption(letter: 'C', text: 'EUR cae, USD/CHF/JPY/Oro suben: modo Risk Off activo, huida hacia refugios'),
        MacroOption(letter: 'D', text: 'El mercado no reacciona hasta que la situación se confirme por medios oficiales'),
      ],
      correctIndex: 2,
      explanation: 'Conflicto en Europa → Risk Off: EUR cae, refugios (USD, CHF, JPY, Oro) suben.',
    ),
    MacroQuestion(
      id: 'q8',
      question: '¿Qué EUR/USD esperás con USA hawkish + crecimiento y Europa dovish + contracción?',
      options: [
        MacroOption(letter: 'A', text: 'Alcista en EUR/USD: Europa tiene potencial de recuperación'),
        MacroOption(letter: 'B', text: 'Bajista en EUR/USD: divergencia total (USA fuerte + hawkish vs Europa débil + dovish)'),
        MacroOption(letter: 'C', text: 'Lateral: hay convergencia porque ambas economías tienen inflación'),
        MacroOption(letter: 'D', text: 'Alcista en EUR/USD: Europa tiene tasas más bajas y eso atrae inversión'),
      ],
      correctIndex: 1,
      explanation: 'Divergencia máxima: USA hawkish + crecimiento vs Europa dovish + contracción → EUR/USD bajista.',
    ),
    MacroQuestion(
      id: 'q9',
      question: 'El petróleo sube +20% en una semana. ¿Qué par operás?',
      options: [
        MacroOption(letter: 'A', text: 'EUR/GBP: ambas economías europeas se ven igual de afectadas'),
        MacroOption(letter: 'B', text: 'AUD/NZD: la correlación con petróleo es indirecta para estas monedas'),
        MacroOption(letter: 'C', text: 'USD/CAD bajista: petróleo sube → CAD se fortalece (Canadá exporta petróleo)'),
        MacroOption(letter: 'D', text: 'GBP/USD alcista: el Reino Unido es importador neto de petróleo'),
      ],
      correctIndex: 2,
      explanation: 'Petróleo sube → CAD se fortalece → USD/CAD baja. Correlación confiable.',
    ),
    MacroQuestion(
      id: 'q10',
      question: 'USA y Europa con mismas tasas, mismo crecimiento, misma inflación. ¿Qué hacés con EUR/USD?',
      options: [
        MacroOption(letter: 'A', text: 'Comprás EUR/USD fuertemente: la convergencia favorece al Euro'),
        MacroOption(letter: 'B', text: 'Vendés EUR/USD fuertemente: cuando todo converge el dólar gana'),
        MacroOption(letter: 'C', text: 'Buscás otro par: esto es convergencia perfecta, EUR/USD estará lateral y destruirá tu ratio'),
        MacroOption(letter: 'D', text: 'Operás en scalping porque en laterales hay más oportunidades'),
      ],
      correctIndex: 2,
      explanation: 'Convergencia perfecta = lateralización. Buscar otro par con divergencia clara.',
    ),
  ];

  static const List<MacroConcept> concepts = [
    MacroConcept(
      id: 'geo',
      title: 'Geopolítica y Refugios',
      emoji: '🌍',
      summary: 'Los conflictos geopolíticos generan huida hacia activos de refugio. Identificar el par correcto según la región del conflicto es clave.',
      inlineQuizzes: [
        MacroInlineQuiz(
          id: 'geo-q1',
          question: 'Conflicto armado en Europa del Este. ¿Qué par operás?',
          options: [
            MacroOption(letter: 'A', text: 'EUR/USD largo (comprar Euro)'),
            MacroOption(letter: 'B', text: 'EUR/CHF corto (vender Euro contra Franco Suizo)'),
            MacroOption(letter: 'C', text: 'GBP/JPY largo (carry trade clásico)'),
          ],
          correctLetter: 'B',
          explanation: 'EUR/CHF vendiendo EUR es el par ideal en conflicto europeo.',
        ),
        MacroInlineQuiz(
          id: 'geo-q2',
          question: 'Crisis política en Brasil. ¿Qué pasa con el Real (BRL)?',
          options: [
            MacroOption(letter: 'A', text: 'Sube por repatriación de capitales'),
            MacroOption(letter: 'B', text: 'Cae por incertidumbre y huida de capitales'),
            MacroOption(letter: 'C', text: 'No se mueve: el BRL ya tiene riesgo país alto incorporado'),
          ],
          correctLetter: 'B',
          explanation: 'El mercado anticipa incertidumbre y huida de capitales → BRL cae.',
        ),
        MacroInlineQuiz(
          id: 'geo-q3',
          question: 'Tensión en Medio Oriente dispara el petróleo. ¿Efecto dominó en USD?',
          options: [
            MacroOption(letter: 'A', text: 'USD cae: el petróleo se compra en otras monedas'),
            MacroOption(letter: 'B', text: 'USD sube: petróleo → inflación → FED hawkish → USD fuerte'),
            MacroOption(letter: 'C', text: 'USD lateral: el petróleo afecta más a emergentes'),
          ],
          correctLetter: 'B',
          explanation: 'Petróleo sube → inflación → FED hawkish → USD sube.',
        ),
        MacroInlineQuiz(
          id: 'geo-q4',
          question: 'Bonos europeos caen (rendimiento sube) por desconfianza. ¿EUR?',
          options: [
            MacroOption(letter: 'A', text: 'EUR sube: los bonos son más atractivos para inversores'),
            MacroOption(letter: 'B', text: 'EUR cae: el rendimiento del bono sube por desconfianza → EUR bajo presión'),
            MacroOption(letter: 'C', text: 'EUR neutral: el mercado descuenta esto hace semanas'),
          ],
          correctLetter: 'B',
          explanation: 'El rendimiento del bono sube por desconfianza → EUR bajo presión.',
        ),
        MacroInlineQuiz(
          id: 'geo-q5',
          question: 'Petróleo sube por tensión geopolítica. ¿Qué par favorece?',
          options: [
            MacroOption(letter: 'A', text: 'EUR/GBP: diversificación europea'),
            MacroOption(letter: 'B', text: 'USD/CAD corto: petróleo fortalece al CAD'),
            MacroOption(letter: 'C', text: 'AUD/JPY: carry trade antipetróleo'),
          ],
          correctLetter: 'B',
          explanation: 'Petróleo sube → CAD fuerte → USD/CAD baja.',
        ),
      ],
    ),
    MacroConcept(
      id: 'div',
      title: 'Diferenciales de Tasas',
      emoji: '📊',
      summary: 'La diferencia de tasas entre dos países determina la dirección estructural de un par. Cuando mayor es el diferencial a favor de un país, más fuerte su moneda en el largo plazo.',
      inlineQuizzes: [
        MacroInlineQuiz(
          id: 'div-q1',
          question: 'FED en 5.25%, BoJ en 0.25%. ¿Tendencia estructural USD/JPY?',
          options: [
            MacroOption(letter: 'A', text: 'Alcista: diferencial masivo a favor del USD'),
            MacroOption(letter: 'B', text: 'Bajista: el Yen es refugio y el carry se revierte'),
            MacroOption(letter: 'C', text: 'Lateral: las tasas no importan en Forex'),
          ],
          correctLetter: 'A',
          explanation: 'Diferencial de tasas FED vs BoJ → USD/JPY alcista estructural.',
        ),
        MacroInlineQuiz(
          id: 'div-esc1',
          question: 'Escenario: USA subiendo tasas + economía fuerte vs Europa bajando tasas + contracción. ¿EUR/USD?',
          options: [
            MacroOption(letter: 'A', text: 'Alcista: Europa se va a recuperar primero'),
            MacroOption(letter: 'B', text: 'Bajista: diferencial a favor del USD + economía USA fuerte'),
            MacroOption(letter: 'C', text: 'Lateral: ambas tienen sus problemas'),
          ],
          correctLetter: 'B',
          explanation: 'Diferencial a favor del USD + economía USA fuerte → EUR/USD bajista.',
        ),
        MacroInlineQuiz(
          id: 'div-esc2',
          question: 'Escenario: Australia sube tasas 50bp mientras USA las mantiene. ¿AUD/USD?',
          options: [
            MacroOption(letter: 'A', text: 'Alcista: diferencial a favor del AUD'),
            MacroOption(letter: 'B', text: 'Bajista: el AUD es commodity-dependiente'),
            MacroOption(letter: 'C', text: 'Lateral: el RBA no tiene credibilidad'),
          ],
          correctLetter: 'A',
          explanation: 'Australia sube tasas mientras USA las baja → AUD/USD alcista.',
        ),
        MacroInlineQuiz(
          id: 'div-esc3',
          question: 'Escenario: USA y Europa con tasas idénticas + inflación idéntica + crecimiento idéntico. ¿EUR/USD?',
          options: [
            MacroOption(letter: 'A', text: 'Alcista: por momentum histórico'),
            MacroOption(letter: 'B', text: 'Bajista: por posicionamiento institucional'),
            MacroOption(letter: 'C', text: 'Lateral: convergencia perfecta, no operes'),
          ],
          correctLetter: 'C',
          explanation: 'Convergencia perfecta → lateralización. Buscar otro par.',
        ),
      ],
    ),
    MacroConcept(
      id: 'ct',
      title: 'Carry Trade',
      emoji: '💱',
      summary: 'Pedir prestado en una moneda de baja tasa para invertir en una de alta tasa. Funciona en Risk On, explota en Risk Off (VIX alto = unwind masivo).',
      inlineQuizzes: [
        MacroInlineQuiz(
          id: 'ct-q1',
          question: 'VIX sube de 14 a 35 en 48h. ¿Qué pasa con AUD/JPY?',
          options: [
            MacroOption(letter: 'A', text: 'Sube: el Yen se debilita con volatilidad'),
            MacroOption(letter: 'B', text: 'Cae: carry unwinding, todos venden AUD y compran JPY'),
            MacroOption(letter: 'C', text: 'Lateral: el VIX no afecta carry trades'),
          ],
          correctLetter: 'B',
          explanation: 'Carry unwinding: todos venden AUD y compran JPY → AUD/JPY cae.',
        ),
        MacroInlineQuiz(
          id: 'ct-q2',
          question: '¿En qué momento se produce el mayor carry unwinding?',
          options: [
            MacroOption(letter: 'A', text: 'Cuando el carry trade recién se inicia'),
            MacroOption(letter: 'B', text: 'Cuando los Bancos Centrales suben tasas'),
            MacroOption(letter: 'C', text: 'Cuando el VIX está alto y hay pánico en los mercados'),
          ],
          correctLetter: 'C',
          explanation: 'VIX alto = pánico → carry unwinding → JPY sube.',
        ),
      ],
    ),
    MacroConcept(
      id: 'cy',
      title: 'Curva de Rendimientos',
      emoji: '📈',
      summary: 'La diferencia entre el rendimiento del bono a 2 años y el del bono a 10 años. Cuando se invierte (2Y > 10Y), es señal de recesión en los próximos 12-18 meses.',
      inlineQuizzes: [
        MacroInlineQuiz(
          id: 'cy-q1',
          question: 'La curva 2Y-10Y se invierte por 6 meses consecutivos. ¿Qué indica?',
          options: [
            MacroOption(letter: 'A', text: 'La economía se está acelerando'),
            MacroOption(letter: 'B', text: 'Señal clásica de recesión en los próximos 12-18 meses'),
            MacroOption(letter: 'C', text: 'El mercado espera más inflación'),
          ],
          correctLetter: 'B',
          explanation: 'Curva invertida (2Y > 10Y) → señal de recesión.',
        ),
        MacroInlineQuiz(
          id: 'cy-q2',
          question: '¿Cuándo suele empezar la recesión según la curva?',
          options: [
            MacroOption(letter: 'A', text: 'Cuando la curva se aplana'),
            MacroOption(letter: 'B', text: 'Cuando la curva se desinvierte (empieza a normalizarse)'),
            MacroOption(letter: 'C', text: 'Cuando la curva se empina demasiado'),
          ],
          correctLetter: 'B',
          explanation: 'La recesión suele empezar cuando la curva se desinvierte.',
        ),
      ],
    ),
    MacroConcept(
      id: 'ce',
      title: 'Ciclo Económico Completo',
      emoji: '🔄',
      summary: 'La economía se mueve en ciclos: Recesión → Recuperación → Expansión →可能的Stagflación. Identificar en qué fase estamos define qué activos operar.',
      inlineQuizzes: [
        MacroInlineQuiz(
          id: 'ce-q1',
          question: '¿Cuándo se considera técnicamente que hay recesión?',
          options: [
            MacroOption(letter: 'A', text: 'Un trimestre de PIB negativo'),
            MacroOption(letter: 'B', text: 'Dos trimestres de PIB negativo + PMI manufacturero bajo'),
            MacroOption(letter: 'C', text: 'Cuando el mercado de acciones cae 20%'),
          ],
          correctLetter: 'B',
          explanation: 'Dos trimestres de PIB negativo + PMI bajo = recesión.',
        ),
        MacroInlineQuiz(
          id: 'ce-q2',
          question: 'El mercado está en plena recesión pero los índices suben. ¿Por qué?',
          options: [
            MacroOption(letter: 'A', text: 'Manipulación institucional'),
            MacroOption(letter: 'B', text: 'El mercado anticipa la recuperación y la política monetaria expansiva'),
            MacroOption(letter: 'C', text: 'Es un rebote técnico solamente'),
          ],
          correctLetter: 'B',
          explanation: 'El mercado anticipa la recuperación → fase 4.',
        ),
        MacroInlineQuiz(
          id: 'ce-q3',
          question: '¿Qué es la stagflación y por qué es el peor escenario?',
          options: [
            MacroOption(letter: 'A', text: 'Crecimiento alto + inflación baja: el paraíso'),
            MacroOption(letter: 'B', text: 'Economía estancada + inflación alta: dilema imposible para el BC'),
            MacroOption(letter: 'C', text: 'Recesión + deflación: clásico de Japón'),
          ],
          correctLetter: 'B',
          explanation: 'Stagflación: dilema imposible para el banco central.',
        ),
      ],
    ),
  ];
}
