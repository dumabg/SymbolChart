// JCL_DEBUG_EXPERT_GENERATEJDBG ON
// JCL_DEBUG_EXPERT_INSERTJDBG ON
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program SymbolChart;

{$R 'FP.res' 'FP.RC'}

uses
  FastMM4 in 'src\FastMM4.pas',
  FastMM4Messages in 'src\FastMM4Messages.pas',
  Forms,
  Dialogs,
  Windows,
  dmBD in 'src\dmBD.pas' {BD: TDataModule},
  fmBase in 'src\base\fmBase.pas' {fBase},
  fmBaseBuscar in 'src\base\fmBaseBuscar.pas' {fBaseBuscar},
  dmInternalServer in 'src\server\dmInternalServer.pas' {InternalServer: TDataModule},
  dmInternalUserServer in 'src\server\dmInternalUserServer.pas' {InternalUserServer: TDataModule},
  dmInternalPerCentServer in 'src\server\dmInternalPerCentServer.pas' {InternalPerCentServer: TDataModule},
  dmLoginServer in 'src\server\dmLoginServer.pas' {LoginServer: TDataModule},
  UserMessages in 'src\util\UserMessages.pas',
  UtilFiles in 'src\util\UtilFiles.pas',
  fmBaseServer in 'src\base\fmBaseServer.pas' {fBaseServer},
  dmConfiguracion in 'src\configuracion\dmConfiguracion.pas' {Configuracion: TDataModule},
  dmServerVersion in 'src\server\dmServerVersion.pas' {ServerVersion: TDataModule},
  wizard in 'src\util\wizard.pas',
  fmBaseEditar in 'src\base\fmBaseEditar.pas' {fBaseEditar},
  UserServerCalls in 'src\server\UserServerCalls.pas',
  UtilDB in 'src\util\UtilDB.pas',
  frCalendario in 'src\util\calendario\frCalendario.pas' {frameCalendario: TFrame},
  calendar2 in 'src\util\calendario\calendar2.pas',
  dmCalendario in 'src\util\calendario\dmCalendario.pas' {Calendario: TDataModule},
  ServerURLs in 'src\server\ServerURLs.pas',
  fmExceptionEnviando in 'src\util\exceptions\fmExceptionEnviando.pas' {fExcepcionEnviando},
  Base64 in 'src\util\Base64.pas',
  Web in 'src\util\Web.pas' {WebAsyncInternal: TDataModule},
  fmAviso in 'src\init\fmAviso.pas' {fAviso},
  dmRecursosListas in 'src\util\dmRecursosListas.pas' {RecursosListas: TDataModule},
  dmCalendarioValor in 'src\util\calendario\dmCalendarioValor.pas' {CalendarioValor: TDataModule},
  UtilImages in 'src\util\UtilImages.pas',
  fmSelectorCampos in 'src\util\selectorCampos\fmSelectorCampos.pas' {fSelectorCampos},
  dmCampos in 'src\util\selectorCampos\dmCampos.pas' {Campos: TDataModule},
  frRentabilidadMercado in 'src\util\rentabilidad\frRentabilidadMercado.pas' {fRentabilidadMercado: TFrame},
  dmRentabilidadMercado in 'src\util\rentabilidad\dmRentabilidadMercado.pas' {RentabilidadMercado: TDataModule},
  UtilString in 'src\util\UtilString.pas',
  dmUltimGridSorter in 'src\util\dmUltimGridSorter.pas' {UltimGridSorter: TDataModule},
  dmDatasetSelector in 'src\util\dmDatasetSelector.pas' {DataSetSelector: TDataModule},
  dmLector in 'src\util\voz\dmLector.pas' {Lector: TDataModule},
  dmLectorImages in 'src\util\voz\dmLectorImages.pas' {LectorImages: TDataModule},
  Tasks in 'src\util\Tasks.pas',
  dmCuentaMovimientosBase in 'src\inversion\dmCuentaMovimientosBase.pas' {CuentaMovimientosBase: TDataModule},
  fmAnadirRetirarCapital in 'src\inversion\fmAnadirRetirarCapital.pas' {fAnadirRetirarCapital},
  UtilForms in 'src\util\UtilForms.pas',
  fmBaseNuevo in 'src\base\fmBaseNuevo.pas' {fBaseNuevo},
  frSeleccionFechas in 'src\util\seleccionFechas\frSeleccionFechas.pas' {fSeleccionFechas: TFrame},
  frCuentaBase in 'src\inversion\frCuentaBase.pas' {fCuentaBase: TFrame},
  dmEstrategiaBase in 'src\inversion\dmEstrategiaBase.pas' {EstrategiaBase: TDataModule},
  Tipos in 'src\util\Tipos.pas',
  dmBroker in 'src\inversion\dmBroker.pas' {Broker: TDataModule},
  dmEstrategiaInterpreter in 'src\inversion\dmEstrategiaInterpreter.pas' {EstrategiaInterpreter: TDataModule},
  fmBaseMasterDetalle in 'src\base\fmBaseMasterDetalle.pas' {fBaseMasterDetalle},
  dmEstrategiaInterpreterBD in 'src\inversion\dmEstrategiaInterpreterBD.pas' {EstrategiaInterpreterBD: TDataModule},
  fmCalculando in 'src\util\fmCalculando.pas' {frCalculando: TFrame},
  UtilException in 'src\util\UtilException.pas',
  eventos in 'src\util\eventos.pas',
  UtilList in 'src\util\UtilList.pas',
  fmCalendario in 'src\util\calendario\fmCalendario.pas' {fCalendario},
  dmMensajeria in 'src\mensajeria\dmMensajeria.pas' {Mensajeria: TDataModule},
  fmBaseCabeceraValor in 'src\base\fmBaseCabeceraValor.pas' {fBaseCabeceraValor},
  frCambioMoneda in 'src\util\moneda\frCambioMoneda.pas' {fCambioMoneda: TFrame},
  fmBasePrecio in 'src\base\fmBasePrecio.pas' {fBasePrecio},
  dmCambioMoneda in 'src\util\moneda\dmCambioMoneda.pas' {CambioMoneda: TDataModule},
  fmCambioMoneda in 'src\util\moneda\fmCambioMoneda.pas' {fCambioMoneda2},
  UtilColors in 'src\util\UtilColors.pas',
  UtilInterfaces in 'src\util\UtilInterfaces.pas' {DataModuleNCR: TDataModule},
  Script in 'src\script\Script.pas',
  ScriptRTTI in 'src\script\ScriptRTTI.pas',
  ConstantsDatosBD in 'src\ConstantsDatosBD.pas',
  uPSI_Broker in 'src\inversion\script\uPSI_Broker.pas',
  uPSI_Datos in 'src\inversion\script\uPSI_Datos.pas',
  uPSI_Log in 'src\inversion\script\uPSI_Log.pas',
  uPSI_Mensaje in 'src\inversion\script\uPSI_Mensaje.pas',
  uPSI_Util in 'src\inversion\script\uPSI_Util.pas',
  fmScriptError in 'src\script\fmScriptError.pas' {fScriptError},
  UtilGrid in 'src\util\UtilGrid.pas' {UtilGridColumnasVisibles: TDataModule},
  dmCuenta in 'src\inversion\dmCuenta.pas' {Cuenta: TDataModule},
  dmCuentaBase in 'src\inversion\dmCuentaBase.pas' {CuentaBase: TDataModule},
  fmCerrarMoneda in 'src\inversion\fmCerrarMoneda.pas' {fCerrarMoneda},
  BusCommunication in 'src\BusCommunication.pas',
  uPanel in 'src\paneles\uPanel.pas' {frPanel: TFrame},
  uPanelMensaje in 'src\paneles\mensaje\uPanelMensaje.pas' {frPanelMensaje: TFrame},
  dmPanelMensaje in 'src\paneles\mensaje\dmPanelMensaje.pas' {PanelMensaje: TDataModule},
  uPanelNotificaciones in 'src\paneles\uPanelNotificaciones.pas' {frPanelNotificaciones: TFrame},
  uPanelIntradia in 'src\paneles\intradia\uPanelIntradia.pas' {frPanelIntradia: TFrame},
  uPanelEscenario in 'src\paneles\escenario\uPanelEscenario.pas' {frEscenario: TFrame},
  uPanelRentabilidadValor in 'src\paneles\rentabilidadValor\uPanelRentabilidadValor.pas' {frPanelRentabilidadValor: TFrame},
  uPanelSwing in 'src\paneles\swing\uPanelSwing.pas' {frPanelSwing: TFrame},
  GraficoPositionLayer in 'src\grafico\GraficoPositionLayer.pas',
  Grafico in 'src\grafico\Grafico.pas',
  uPanelValor in 'src\paneles\valor\uPanelValor.pas' {frPanelValor: TFrame},
  uPanelInhibidores in 'src\paneles\inhibidores\uPanelInhibidores.pas' {frPanelInhibidores: TFrame},
  dmPanelInhibidores in 'src\paneles\inhibidores\dmPanelInhibidores.pas' {PanelInhibidores: TDataModule},
  uPanelRentabilidadMercado in 'src\paneles\rentabilidadMercado\uPanelRentabilidadMercado.pas' {frPanelRentabilidadMercado: TFrame},
  dmPanelRentabilidadValor in 'src\paneles\rentabilidadValor\dmPanelRentabilidadValor.pas' {RentabilidadValor: TDataModule},
  dmPanelSwing in 'src\paneles\swing\dmPanelSwing.pas' {PanelSwing: TDataModule},
  uAcciones in 'src\acciones\uAcciones.pas' {Acciones: TFrame},
  uAccionesAyuda in 'src\acciones\ayuda\uAccionesAyuda.pas' {AccionesAyuda: TFrame},
  uAccionesVer in 'src\acciones\ver\uAccionesVer.pas' {AccionesVer: TFrame},
  uAccionesValor in 'src\acciones\valor\uAccionesValor.pas' {AccionesValor: TFrame},
  uAccionesGrafico in 'src\acciones\grafico\uAccionesGrafico.pas' {AccionesGrafico: TFrame},
  uAccionesHerramientas in 'src\acciones\herramientas\uAccionesHerramientas.pas' {AccionesHerramientas: TFrame},
  uAccionesEscenarios in 'src\acciones\escenarios\uAccionesEscenarios.pas' {AccionesEscenarios: TFrame},
  uPanelFavoritos in 'src\paneles\favoritos\uPanelFavoritos.pas' {frPanelFavoritos: TFrame},
  fmRecordatorio in 'src\acciones\ver\fmRecordatorio.pas' {fRecordatorio},
  fmMapaValores in 'src\acciones\valor\mapa\fmMapaValores.pas' {fMapaValores},
  dmMapaValores in 'src\acciones\valor\mapa\dmMapaValores.pas' {MapaValores: TDataModule},
  GraficoBolsa in 'src\grafico\GraficoBolsa.pas',
  GraficoEscenario in 'src\grafico\GraficoEscenario.pas',
  GraficoVelas in 'src\grafico\GraficoVelas.pas',
  GraficoDataHintLayer in 'src\grafico\GraficoDataHintLayer.pas',
  Escenario in 'src\acciones\escenarios\Escenario.pas',
  EscenarioController in 'src\acciones\escenarios\EscenarioController.pas',
  dmBaseBuscar in 'src\base\dmBaseBuscar.pas' {BaseBuscar: TDataModule},
  fmBuscarValor in 'src\acciones\valor\buscar\fmBuscarValor.pas' {fBuscarValor},
  dmBuscarValor in 'src\acciones\valor\buscar\dmBuscarValor.pas' {BuscarValor: TDataModule},
  fmComentario in 'src\acciones\valor\comentario\fmComentario.pas' {fComentario},
  dmComentario in 'src\acciones\valor\comentario\dmComentario.pas' {dComentario: TDataModule},
  fmGrupos in 'src\acciones\valor\grupos\fmGrupos.pas' {fGrupos},
  dmGrupos in 'src\acciones\valor\grupos\dmGrupos.pas' {Grupos: TDataModule},
  dmValoresLoader in 'src\datos\dmValoresLoader.pas' {ValoresLoader: TDataModule},
  dmValoresLoaderTodos in 'src\datos\dmValoresLoaderTodos.pas' {ValoresLoaderTodos: TDataModule},
  dmValoresLoaderGrupo in 'src\datos\dmValoresLoaderGrupo.pas' {ValoresLoaderGrupo: TDataModule},
  dmValoresLoaderMercado in 'src\datos\dmValoresLoaderMercado.pas' {ValoresLoaderMercado: TDataModule},
  dmValoresLoaderIndice in 'src\datos\dmValoresLoaderIndice.pas' {ValoresLoaderIndice: TDataModule},
  dmValoresLoaderMercadoIndices in 'src\datos\dmValoresLoaderMercadoIndices.pas' {ValoresLoaderMercadoIndices: TDataModule},
  dmValoresLoaderCarteraPendientes in 'src\datos\dmValoresLoaderCarteraPendientes.pas' {ValoresLoaderCarteraPendientes: TDataModule},
  dmValoresLoaderCarteraAbiertas in 'src\datos\dmValoresLoaderCarteraAbiertas.pas' {ValoresLoaderCarteraAbiertas: TDataModule},
  dmValoresLoaderTodosPaises in 'src\datos\dmValoresLoaderTodosPaises.pas' {ValoresLoaderTodosPaises: TDataModule},
  dmAccionesValor in 'src\acciones\valor\dmAccionesValor.pas' {DataAccionesValor: TDataModule},
  fmRentabilidadMercados in 'src\acciones\herramientas\Rentabilidad mercados\fmRentabilidadMercados.pas' {fRentabilidadMercados},
  dmRentabilidadMercados in 'src\acciones\herramientas\Rentabilidad mercados\dmRentabilidadMercados.pas' {RentabilidadMercados: TDataModule},
  dmImportarDatos in 'src\acciones\herramientas\actualizarDatos\dmImportarDatos.pas' {ImportarDatos: TDataModule},
  dmSaldo in 'src\acciones\herramientas\actualizarDatos\dmSaldo.pas' {Saldo: TDataModule},
  fmActualizarDatos in 'src\acciones\herramientas\actualizarDatos\fmActualizarDatos.pas' {fActualizarDatos},
  fmActualizarDatosPageWizard in 'src\acciones\herramientas\actualizarDatos\fmActualizarDatosPageWizard.pas' {fActualizarDatosPage},
  fmLoginActualizar in 'src\acciones\herramientas\actualizarDatos\fmLoginActualizar.pas' {fLoginActualizar},
  fmLoginActualizarPageWizard in 'src\acciones\herramientas\actualizarDatos\fmLoginActualizarPageWizard.pas' {fLoginActualizarPageWizard},
  fmMensaje in 'src\acciones\herramientas\actualizarDatos\fmMensaje.pas' {fMensaje},
  fmMensajePageWizard in 'src\acciones\herramientas\actualizarDatos\fmMensajePageWizard.pas' {fMensajePageWizard},
  fmResumen in 'src\acciones\herramientas\actualizarDatos\fmResumen.pas' {fResumen},
  fmResumenPageWizard in 'src\acciones\herramientas\actualizarDatos\fmResumenPageWizard.pas' {fResumenPageWizard},
  fmSaldo in 'src\acciones\herramientas\actualizarDatos\fmSaldo.pas' {fSaldo},
  frValorAnalisis in 'src\acciones\herramientas\analisis\frValorAnalisis.pas' {ValorAnalisis: TFrame},
  dmAnalisisRapido in 'src\acciones\herramientas\analisis\dmAnalisisRapido.pas' {AnalisisRapido: TDataModule},
  fmAnalisisRapido in 'src\acciones\herramientas\analisis\fmAnalisisRapido.pas' {fAnalisisRapido},
  fmBloquear in 'src\acciones\herramientas\bloquear\fmBloquear.pas' {fBloquear},
  fmNuevoBroker in 'src\acciones\herramientas\brokers\fmNuevoBroker.pas' {fNuevoBroker},
  dmBrokers in 'src\acciones\herramientas\brokers\dmBrokers.pas' {Brokers: TDataModule},
  fmBrokers in 'src\acciones\herramientas\brokers\fmBrokers.pas' {fBrokers},
  fmPosicionMercado in 'src\acciones\herramientas\cartera\fmPosicionMercado.pas' {fPosicionMercado},
  dmAnadirValorCartera in 'src\acciones\herramientas\cartera\dmAnadirValorCartera.pas' {AnadirValorCartera: TDataModule},
  dmBrokerCartera in 'src\acciones\herramientas\cartera\dmBrokerCartera.pas' {BrokerCartera: TDataModule},
  dmEstrategiaCartera in 'src\acciones\herramientas\cartera\dmEstrategiaCartera.pas' {EstrategiaCartera: TDataModule},
  dmInversor in 'src\acciones\herramientas\cartera\dmInversor.pas' {Inversor: TDataModule},
  dmInversorCartera in 'src\acciones\herramientas\cartera\dmInversorCartera.pas' {InversorCartera: TDataModule},
  dmNuevaCartera in 'src\acciones\herramientas\cartera\dmNuevaCartera.pas' {NuevaCartera: TDataModule},
  fmAnadirValorCartera in 'src\acciones\herramientas\cartera\fmAnadirValorCartera.pas' {fAnadirValorCartera},
  fmCerrarPosicion in 'src\acciones\herramientas\cartera\fmCerrarPosicion.pas' {fCerrarPosicion},
  fmCuentaCartera in 'src\acciones\herramientas\cartera\fmCuentaCartera.pas' {fCuentaCartera: TFrame},
  fmMultiCerrarPosicion in 'src\acciones\herramientas\cartera\fmMultiCerrarPosicion.pas' {fMultiCerrarPosicion},
  fmNuevaCartera in 'src\acciones\herramientas\cartera\fmNuevaCartera.pas' {fNuevaCartera},
  fmConfiguracion in 'src\acciones\herramientas\configuracion\fmConfiguracion.pas' {fConfiguracion},
  fmCorreo in 'src\acciones\herramientas\correo\fmCorreo.pas' {fCorreo},
  dmCorreo in 'src\acciones\herramientas\correo\dmCorreo.pas' {Correo: TDataModule},
  fmEstadoCuentaCargando in 'src\acciones\herramientas\cuenta\fmEstadoCuentaCargando.pas' {fEstadoCuentaCargando},
  dmEstadoCuenta in 'src\acciones\herramientas\cuenta\dmEstadoCuenta.pas' {EstadoCuenta: TDataModule},
  fmEstadoCuenta in 'src\acciones\herramientas\cuenta\fmEstadoCuenta.pas' {fEstadoCuenta},
  fmEstrategias in 'src\acciones\herramientas\estrategias\fmEstrategias.pas' {fEstrategias},
  dmEstrategias in 'src\acciones\herramientas\estrategias\dmEstrategias.pas' {Estrategias: TDataModule},
  frEstudioCuenta in 'src\acciones\herramientas\estudio\frEstudioCuenta.pas' {fEstudioCuenta: TFrame},
  dmBrokerEstudio in 'src\acciones\herramientas\estudio\dmBrokerEstudio.pas' {BrokerEstudio: TDataModule},
  dmEstrategiaEstudio in 'src\acciones\herramientas\estudio\dmEstrategiaEstudio.pas' {EstrategiaEstudio: TDataModule},
  dmEstudioNuevo in 'src\acciones\herramientas\estudio\dmEstudioNuevo.pas' {EstudioNuevo: TDataModule},
  dmEstudios in 'src\acciones\herramientas\estudio\dmEstudios.pas' {Estudios: TDataModule},
  dmEstudioScriptError in 'src\acciones\herramientas\estudio\dmEstudioScriptError.pas' {EstudioScriptError: TDataModule},
  dmInversorEstudio in 'src\acciones\herramientas\estudio\dmInversorEstudio.pas' {InversorEstudio: TDataModule},
  fmEstudioNuevo in 'src\acciones\herramientas\estudio\fmEstudioNuevo.pas' {fEstudioNuevo},
  fmEstudios in 'src\acciones\herramientas\estudio\fmEstudios.pas' {fEstudios},
  fmExportar in 'src\acciones\herramientas\exportar\fmExportar.pas' {fExportar},
  dmExportar in 'src\acciones\herramientas\exportar\dmExportar.pas' {Exportar: TDataModule},
  fmStopsManuales in 'src\acciones\herramientas\stops\fmStopsManuales.pas' {fStopsManuales},
  dmStopsManuales in 'src\acciones\herramientas\stops\dmStopsManuales.pas' {StopsManuales: TDataModule},
  fmActualizarStopManual in 'src\acciones\herramientas\stops\fmActualizarStopManual.pas' {fActualizarStopManual},
  fmActualizarDatosWizard in 'src\acciones\herramientas\actualizarDatos\fmActualizarDatosWizard.pas' {fActualizarDatosWizard},
  fmSaldoPageWizard in 'src\acciones\herramientas\actualizarDatos\fmSaldoPageWizard.pas' {fSaldoPage},
  fmCartera in 'src\acciones\herramientas\cartera\fmCartera.pas' {fCartera},
  dmCartera in 'src\acciones\herramientas\cartera\dmCartera.pas' {Cartera: TDataModule},
  dmCuentaEstudio in 'src\acciones\herramientas\estudio\dmCuentaEstudio.pas' {CuentaEstudio: TDataModule},
  uPanelCotizaciones in 'src\paneles\cotizaciones\uPanelCotizaciones.pas' {frPanelCotizaciones: TFrame},
  fmBasePestanas in 'src\base\fmBasePestanas.pas' {fBasePestanas},
  frModuloVersion in 'src\acciones\herramientas\configuracion\frModuloVersion.pas' {fModuloVersion: TFrame},
  ConfigVersion in 'src\configuracion\ConfigVersion.pas',
  dmSistemaStorage in 'src\util\dmSistemaStorage.pas' {SistemaStorage: TDataModule},
  dmConfigSistema in 'src\configuracion\dmConfigSistema.pas' {ConfigSistema: TDataModule},
  frModuloEscenarios in 'src\acciones\herramientas\configuracion\frModuloEscenarios.pas' {fModuloEscenarios: TFrame},
  ConfigEscenarios in 'src\configuracion\ConfigEscenarios.pas',
  ConfigIdentificacion in 'src\configuracion\ConfigIdentificacion.pas',
  frModulo in 'src\acciones\herramientas\configuracion\frModulo.pas' {fModulo: TFrame},
  frModuloMensajes in 'src\acciones\herramientas\configuracion\frModuloMensajes.pas' {fModuloMensajes: TFrame},
  dmConfigMensajes in 'src\configuracion\dmConfigMensajes.pas' {ConfigMensajes: TDataModule},
  frModuloIdentificacion in 'src\acciones\herramientas\configuracion\frModuloIdentificacion.pas' {fModuloIdentificacion: TFrame},
  frModuloRecordatorio in 'src\acciones\herramientas\configuracion\frModuloRecordatorio.pas' {fModuloRecordatorio: TFrame},
  ConfigRecordatorio in 'src\configuracion\ConfigRecordatorio.pas',
  frModuloVoz in 'src\acciones\herramientas\configuracion\frModuloVoz.pas' {fModuloVoz: TFrame},
  ConfigVoz in 'src\configuracion\ConfigVoz.pas',
  FPLoader in 'src\FPLoader.pas',
  ConfigGrids in 'src\configuracion\ConfigGrids.pas',
  UtilDock in 'src\util\UtilDock.pas',
  frRichEdit in 'src\util\frRichEdit.pas' {fRichEdit: TFrame},
  frEditorCodigo in 'src\util\codigo\frEditorCodigo.pas' {fEditorCodigo: TFrame},
  dmFS in 'src\util\FS\dmFS.pas' {FS: TDataModule},
  frFS in 'src\util\FS\frFS.pas' {fFS: TFrame},
  uAccionesConsultas in 'src\acciones\consultas\uAccionesConsultas.pas' {AccionesConsultas: TFrame},
  SCMain in 'src\SCMain.pas' {fSCMain},
  fmEditFS in 'src\util\FS\fmEditFS.pas' {fEditableFS},
  fmConsultas in 'src\acciones\consultas\fmConsultas.pas' {fConsultas},
  dmConsultas in 'src\acciones\consultas\dmConsultas.pas' {Consultas: TDataModule},
  dmConsulta in 'src\acciones\consultas\dmConsulta.pas' {Consulta: TDataModule},
  frEditFS in 'src\util\FS\frEditFS.pas' {fEditFS: TFrame},
  dmEditFS in 'src\util\FS\dmEditFS.pas' {EditFS: TDataModule},
  fmSeleccionarFS in 'src\util\FS\fmSeleccionarFS.pas' {fSeleccionarFS},
  BDConstants in 'src\BDConstants.pas',
  fmConsulta in 'src\acciones\consultas\fmConsulta.pas' {fConsulta},
  GraficoLineasLayer in 'src\grafico\GraficoLineasLayer.pas',
  dmPanelIndicadores in 'src\paneles\indicadores\dmPanelIndicadores.pas' {PanelIndicadores: TDataModule},
  uPanelIndicadores in 'src\paneles\indicadores\uPanelIndicadores.pas' {frPanelIndicadores: TFrame},
  fmColumna in 'src\acciones\consultas\fmColumna.pas' {fColumna},
  ksTimers in 'src\util\ksTimers.pas',
  dmDataModuleBase in 'src\util\dmDataModuleBase.pas' {DataModuleBase: TDataModule},
  frCargando in 'src\util\frCargando.pas' {fCargando: TFrame},
  KeyHook in 'src\util\KeyHook.pas',
  dmPanelEscenario in 'src\paneles\escenario\dmPanelEscenario.pas' {PanelEscenario: TDataModule},
  GraficoZoom in 'src\grafico\GraficoZoom.pas',
  GraficoLineas in 'src\grafico\GraficoLineas.pas',
  UtilDBSC in 'src\util\UtilDBSC.pas',
  fmTareas in 'src\acciones\herramientas\tareas\fmTareas.pas' {fTareas},
  dmTareas in 'src\acciones\herramientas\tareas\dmTareas.pas' {Tareas: TDataModule},
  UtilResources in 'src\util\UtilResources.pas',
  fmSplash in 'src\init\fmSplash.pas' {fSplash},
  dmTipOfDay in 'src\init\dmTipOfDay.pas' {TipOfDay: TDataModule},
  IBQueryHelper in 'src\util\IBQueryHelper.pas',
  fmBaseFormConfig in 'src\base\fmBaseFormConfig.pas' {fBaseFormConfig},
  ConfigVisual in 'src\util\config\ConfigVisual.pas',
  fmBaseFormVisualConfig in 'src\base\fmBaseFormVisualConfig.pas' {fBaseFormVisualConfig},
  uTickService in 'src\servicios\uTickService.pas',
  dmPanelIntradia in 'src\paneles\intradia\dmPanelIntradia.pas' {PanelIntradia: TDataModule},
  dmCrearEstudio in 'src\acciones\herramientas\estudio\dmCrearEstudio.pas' {CrearEstudio: TDataModule},
  frEditorCodigoDatos in 'src\util\codigo\frEditorCodigoDatos.pas' {fEditorCodigoDatos: TFrame},
  dmDataComun in 'src\data\dmDataComun.pas' {DataComun: TDataModule},
  dmData in 'src\data\dmData.pas' {Data: TDataModule},
  dmDataComunSesion in 'src\data\dmDataComunSesion.pas' {DataComunSesion: TDataModule},
  dmConsultasMenu in 'src\acciones\consultas\dmConsultasMenu.pas' {ConsultasMenuData: TDataModule},
  uServices in 'src\servicios\uServices.pas',
  dmHandledDataModule in 'src\base\dmHandledDataModule.pas' {HandledDataModule: TDataModule},
  UtilObject in 'src\util\UtilObject.pas',
  UtilThread in 'src\util\thread\UtilThread.pas',
  dmThreadDataModule in 'src\util\thread\dmThreadDataModule.pas' {ThreadDataModule: TDataModule},
  UtilType in 'src\util\UtilType.pas',
  uToolbarGrafico in 'src\paneles\grafico\uToolbarGrafico.pas' {frToolbarGrafico: TFrame},
  dmOsciladores in 'src\paneles\grafico\dmOsciladores.pas' {Osciladores: TDataModule},
  GraficoOscilador in 'src\paneles\grafico\GraficoOscilador.pas',
  fmOsciladores in 'src\paneles\grafico\fmOsciladores.pas' {fOsciladores},
  UtilFS in 'src\util\FS\UtilFS.pas',
  dmToolbarGrafico in 'src\paneles\grafico\dmToolbarGrafico.pas' {ToolbarGrafico: TDataModule},
  DatosGrafico in 'src\grafico\DatosGrafico.pas',
  GraficoValor in 'src\paneles\grafico\GraficoValor.pas',
  IncrustedDatosLineLayer in 'src\grafico\IncrustedDatosLineLayer.pas',
  dmGraficoValorLayer in 'src\paneles\grafico\dmGraficoValorLayer.pas' {DataGraficoValorLayer: TDataModule},
  IncrustedItems in 'src\grafico\IncrustedItems.pas',
  dmDataCache in 'src\data\dmDataCache.pas' {DataCache: TDataModule},
  LinePainter in 'src\grafico\painter\LinePainter.pas',
  fmAcercaDe in 'src\acciones\ayuda\fmAcercaDe.pas' {fAcercaDe},
  dmEstudio in 'src\acciones\herramientas\estudio\dmEstudio.pas' {DataEstudio: TDataModule},
  frUsuario in 'src\server\frUsuario.pas' {fUsuario: TFrame},
  flags in 'src\util\flags.pas',
  SpeechLib_TLB in 'src\util\SpeechLib_TLB.pas',
  UtilWeb in 'src\util\UtilWeb.pas',
  uExceptionsManager in 'src\util\exceptions\uExceptionsManager.pas',
  dmDescargarDatos in 'src\acciones\herramientas\actualizarDatos\dmDescargarDatos.pas' {DescargarDatos: TDataModule},
  dmActualizarDatos in 'src\acciones\herramientas\actualizarDatos\dmActualizarDatos.pas' {ActualizarDatos: TDataModule},
  fmLogin in 'src\server\fmLogin.pas' {fLogin},
  uPanelCambioDia in 'src\paneles\cambioDia\uPanelCambioDia.pas' {frPanelCambioDia: TFrame},
  uPanelCaos in 'src\paneles\caos\uPanelCaos.pas' {frPanelCaos: TFrame},
  dmAccionesCartera in 'src\acciones\herramientas\cartera\dmAccionesCartera.pas' {AccionesCartera: TDataModule},
  dmEstadoValores in 'src\acciones\valor\filtros\dmEstadoValores.pas' {EstadoValores: TDataModule},
  dmEstadoValoresFactory in 'src\acciones\valor\filtros\dmEstadoValoresFactory.pas' {EstadoValoresFactory: TDataModule},
  dmFiltro in 'src\acciones\valor\filtros\dmFiltro.pas' {Filtro: TDataModule},
  dmFiltroAcumulacionDinero in 'src\acciones\valor\filtros\dmFiltroAcumulacionDinero.pas' {FiltroAcumulacionDinero: TDataModule},
  dmFiltroAcumulacionDobson in 'src\acciones\valor\filtros\dmFiltroAcumulacionDobson.pas' {FiltroAcumulacionDobson: TDataModule},
  dmFiltroBajadaAcumulacion in 'src\acciones\valor\filtros\dmFiltroBajadaAcumulacion.pas' {FiltroBajadaAcumulacion: TDataModule},
  dmFiltroCaidaLibreHamiltoniana in 'src\acciones\valor\filtros\dmFiltroCaidaLibreHamiltoniana.pas' {FiltroCaidaLibreHamiltoniana: TDataModule},
  dmFiltroCaidaLibreTecnica in 'src\acciones\valor\filtros\dmFiltroCaidaLibreTecnica.pas' {FiltroCaidaLibreTecnica: TDataModule},
  dmFiltroCambioDireccional in 'src\acciones\valor\filtros\dmFiltroCambioDireccional.pas' {FiltroCambioDireccional: TDataModule},
  dmFiltroDistribucionDobson in 'src\acciones\valor\filtros\dmFiltroDistribucionDobson.pas' {FiltroDistribucionDobson: TDataModule},
  dmFiltroDistribucionPapel in 'src\acciones\valor\filtros\dmFiltroDistribucionPapel.pas' {FiltroDistribucionPapel: TDataModule},
  dmFiltroEntornoAcumulativo in 'src\acciones\valor\filtros\dmFiltroEntornoAcumulativo.pas' {FiltroEntornoAcumulativo: TDataModule},
  dmFiltroEntornoDistributivo in 'src\acciones\valor\filtros\dmFiltroEntornoDistributivo.pas' {FiltroEntornoDistributivo: TDataModule},
  dmFiltroFactory in 'src\acciones\valor\filtros\dmFiltroFactory.pas' {FiltrosFactory: TDataModule},
  dmFiltroLimiteSobrecompraCorto in 'src\acciones\valor\filtros\dmFiltroLimiteSobrecompraCorto.pas' {FiltroLimiteSobrecompraCorto: TDataModule},
  dmFiltroLimiteSobreventaCorto in 'src\acciones\valor\filtros\dmFiltroLimiteSobreventaCorto.pas' {FiltroLimiteSobreventaCorto: TDataModule},
  dmFiltroNeutral in 'src\acciones\valor\filtros\dmFiltroNeutral.pas' {FiltroNeutral: TDataModule},
  dmFiltroNeutralCorto in 'src\acciones\valor\filtros\dmFiltroNeutralCorto.pas' {FiltroNeutralCorto: TDataModule},
  dmFiltroNoblementeAlza in 'src\acciones\valor\filtros\dmFiltroNoblementeAlza.pas' {FiltroNoblementeAlza: TDataModule},
  dmFiltroPerforacionCatastrofe in 'src\acciones\valor\filtros\dmFiltroPerforacionCatastrofe.pas' {FiltroPerforacionCatastrofe: TDataModule},
  dmFiltroPerforacionCatastrofeAlcista in 'src\acciones\valor\filtros\dmFiltroPerforacionCatastrofeAlcista.pas' {FiltroPerforacionCatastrofeAlcista: TDataModule},
  dmFiltroPerforacionCatastrofeBajista in 'src\acciones\valor\filtros\dmFiltroPerforacionCatastrofeBajista.pas' {FiltroPerforacionCatastrofeBajista: TDataModule},
  dmFiltroResistencia in 'src\acciones\valor\filtros\dmFiltroResistencia.pas' {FiltroResistencia: TDataModule},
  dmFiltros in 'src\acciones\valor\filtros\dmFiltros.pas' {Filtros: TDataModule},
  dmFiltroSobrecompradoCorto in 'src\acciones\valor\filtros\dmFiltroSobrecompradoCorto.pas' {FiltroSobrecompradoCorto: TDataModule},
  dmFiltroSobrecompradoLargo in 'src\acciones\valor\filtros\dmFiltroSobrecompradoLargo.pas' {FiltroSobrecompradoLargo: TDataModule},
  dmFiltroSobrevendidoCorto in 'src\acciones\valor\filtros\dmFiltroSobrevendidoCorto.pas' {FiltroSobrevendidoCorto: TDataModule},
  dmFiltroSobrevendidoLargo in 'src\acciones\valor\filtros\dmFiltroSobrevendidoLargo.pas' {FiltroSobrevendidoLargo: TDataModule},
  dmFiltroSoporte in 'src\acciones\valor\filtros\dmFiltroSoporte.pas' {FiltroSoporte: TDataModule},
  dmFiltroSubidaDistribucion in 'src\acciones\valor\filtros\dmFiltroSubidaDistribucion.pas' {FiltroSubidaDistribucion: TDataModule},
  dmFiltroSubidaLibreHamiltoniana in 'src\acciones\valor\filtros\dmFiltroSubidaLibreHamiltoniana.pas' {FiltroSubidaLibreHamiltoniana: TDataModule},
  dmFiltroSuelo in 'src\acciones\valor\filtros\dmFiltroSuelo.pas' {FiltroSuelo: TDataModule},
  dmSubidaLibreTecnica in 'src\acciones\valor\filtros\dmSubidaLibreTecnica.pas' {FiltroSubidaLibreTecnica: TDataModule},
  dmFiltroCaenBajadaLibre in 'src\acciones\valor\filtros\dmFiltroCaenBajadaLibre.pas' {FiltroCaenBajadaLibre: TDataModule},
  dmFiltroCatastrofeBajista in 'src\acciones\valor\filtros\dmFiltroCatastrofeBajista.pas' {FiltroCatastrofeBajista: TDataModule},
  dmFiltroCatastrofeAlcista in 'src\acciones\valor\filtros\dmFiltroCatastrofeAlcista.pas' {FiltroCatastrofeAlcista: TDataModule},
  dmFiltroSubenSubidaLibre in 'src\acciones\valor\filtros\dmFiltroSubenSubidaLibre.pas' {FiltroSubenSubidaLibre: TDataModule},
  fmFiltros in 'src\acciones\valor\filtros\fmFiltros.pas' {fFiltros},
  fmPanelGrafico in 'src\acciones\grafico\fmPanelGrafico.pas' {frPanelGrafico: TFrame},
  fmPanelRecorrido in 'src\acciones\grafico\fmPanelRecorrido.pas' {frPanelRecorrido: TFrame},
  dmPanelRecorrido in 'src\acciones\grafico\dmPanelRecorrido.pas' {PanelRecorrido: TDataModule},
  UtilFrames in 'src\util\UtilFrames.pas',
  fmPanelRSI in 'src\acciones\grafico\fmPanelRSI.pas' {fPanelRSI: TFrame},
  dmPanelRSI in 'src\acciones\grafico\dmPanelRSI.pas' {PanelRSI: TDataModule},
  dmGraficoBolsa in 'src\grafico\dmGraficoBolsa.pas' {DataGraficoBolsa: TDataModule},
  GR32_VectorMaps in 'src\grafico\gr32\GR32_VectorMaps.pas',
  GR32 in 'src\grafico\gr32\GR32.pas',
  GR32_Blend in 'src\grafico\gr32\GR32_Blend.pas',
  GR32_Containers in 'src\grafico\gr32\GR32_Containers.pas',
  GR32_DrawingEx in 'src\grafico\gr32\GR32_DrawingEx.pas',
  GR32_ExtImage in 'src\grafico\gr32\GR32_ExtImage.pas',
  GR32_Filters in 'src\grafico\gr32\GR32_Filters.pas',
  GR32_Image in 'src\grafico\gr32\GR32_Image.pas',
  GR32_Layers in 'src\grafico\gr32\GR32_Layers.pas',
  GR32_LowLevel in 'src\grafico\gr32\GR32_LowLevel.pas',
  GR32_Math in 'src\grafico\gr32\GR32_Math.pas',
  GR32_MicroTiles in 'src\grafico\gr32\GR32_MicroTiles.pas',
  GR32_OrdinalMaps in 'src\grafico\gr32\GR32_OrdinalMaps.pas',
  GR32_Polygons in 'src\grafico\gr32\GR32_Polygons.pas',
  GR32_RangeBars in 'src\grafico\gr32\GR32_RangeBars.pas',
  GR32_Rasterizers in 'src\grafico\gr32\GR32_Rasterizers.pas',
  GR32_RepaintOpt in 'src\grafico\gr32\GR32_RepaintOpt.pas',
  GR32_Resamplers in 'src\grafico\gr32\GR32_Resamplers.pas',
  GR32_System in 'src\grafico\gr32\GR32_System.pas',
  GR32_Transforms in 'src\grafico\gr32\GR32_Transforms.pas',
  GraficoEscenarioPositionLayer in 'src\grafico\GraficoEscenarioPositionLayer.pas',
  ExceptionsState in 'src\util\exceptions\ExceptionsState.pas',
  fmExceptionLauncher in 'src\util\exceptions\fmExceptionLauncher.pas' {fExceptionLauncher},
  fmException in 'src\util\exceptions\fmException.pas' {fException},
  dmValoresLoaderPais in 'src\datos\dmValoresLoaderPais.pas' {ValoresLoaderPais: TDataModule},
  GlobalInit in 'src\init\GlobalInit.pas',
  GlobalSyncronization in 'src\util\thread\GlobalSyncronization.pas',
  Valores in 'src\datos\Valores.pas',
  ScriptEngine in 'src\script\ScriptEngine.pas',
  ScriptExpressionEngine in 'src\script\ScriptExpressionEngine.pas',
  ScriptEstrategia in 'src\inversion\script\ScriptEstrategia.pas',
  ScriptEditorCodigoDatos in 'src\util\codigo\ScriptEditorCodigoDatos.pas',
  ScriptComision in 'src\inversion\ScriptComision.pas',
  ScriptObject in 'src\script\ScriptObject.pas',
  Script_Broker in 'src\inversion\script\Script_Broker.pas',
  Script_Datos in 'src\inversion\script\Script_Datos.pas',
  Script_Log in 'src\inversion\script\Script_Log.pas',
  Script_Mensaje in 'src\inversion\script\Script_Mensaje.pas',
  Script_Util in 'src\inversion\script\Script_Util.pas',
  ScriptDataCacheHorizontal in 'src\script\ScriptDataCacheHorizontal.pas',
  ScriptDataCacheVertical in 'src\script\ScriptDataCacheVertical.pas',
  ScriptDataCache in 'src\script\ScriptDataCache.pas',
  ScriptDatosEngine in 'src\inversion\script\ScriptDatosEngine.pas',
  frLogin in 'src\server\frLogin.pas' {frameLogin: TFrame},
  frLoginServer in 'src\server\frLoginServer.pas' {fLoginServer: TFrame},
  calculos in 'src\util\calculos.pas',
  dmConsultaGrupo in 'src\acciones\consultas\dmConsultaGrupo.pas' {ConsultaGrupo: TDataModule},
  fmConsultaNuevoGrupo in 'src\acciones\consultas\fmConsultaNuevoGrupo.pas' {fConsultaNuevoGrupo},
  fmRanquing in 'src\acciones\herramientas\ranquing\fmRanquing.pas' {fRanquing},
  dmRanquing in 'src\acciones\herramientas\ranquing\dmRanquing.pas' {Ranquing: TDataModule},
  fmPanelRanquing in 'src\acciones\grafico\fmPanelRanquing.pas' {frPanelRanquing: TFrame},
  dmPanelRanquing in 'src\acciones\grafico\dmPanelRanquing.pas' {PanelRanquing: TDataModule},
  fmPlusvaliaRiesgo in 'src\acciones\escenarios\fmPlusvaliaRiesgo.pas' {fPlusvaliaRiesgo},
  dmPlusvaliaRiesgo in 'src\acciones\escenarios\dmPlusvaliaRiesgo.pas' {PlusvaliaRiesgo: TDataModule},
  fmPanelEstrategia in 'src\acciones\grafico\fmPanelEstrategia.pas' {frPanelEstrategia: TFrame},
  dataPanelEstrategia in 'src\acciones\grafico\dataPanelEstrategia.pas',
  fmMensajeEstrategia in 'src\acciones\grafico\fmMensajeEstrategia.pas' {fMensajeEstrategia},
  fmEstadistica in 'src\acciones\herramientas\estadistica\fmEstadistica.pas' {fEstadistica},
  dmEstadistica in 'src\acciones\herramientas\estadistica\dmEstadistica.pas' {Estadistica: TDataModule},
  GraficoEstrategia in 'src\acciones\grafico\GraficoEstrategia.pas',
  mensajesPanel in 'src\comun\mensajesPanel.pas',
  imagesMensajesPanel in 'src\comun\imagesMensajesPanel.pas',
  uEstrategia in 'src\acciones\grafico\uEstrategia.pas',
  mabg in 'src\util\mabg.pas';

{$R *.res}

resourcestring
  ERROR_BD = 'No se ha podido conectar con la base de datos.' + sLineBreak +
    '�Se ha instalado el programa correctamente?';

begin
  GlobalInit.GlobalInitialization;
  try
    Application.Initialize;
    Application.Title := 'SymbolChart';
    Application.CreateForm(TTareas, Tareas);
  if (BD.IBDatabaseUsuario.Connected) and (BD.IBDatabaseComun.Connected) then begin
      Configuracion := TConfiguracion.Create(Application);
      ConfiguracionVisual := TConfiguracionVisual.Create;
      if Precondiciones then begin
        InitializeEnvironment;
        ShowSplash;
        Application.CreateForm(TDataComun, DataComun);
        Application.CreateForm(TRecursosListas, RecursosListas);
        Application.CreateForm(TData, Data);
        Application.HintHidePause := -1;
        Application.CreateForm(TfSCMain, fSCMain);
        MostrarAvisoSiExiste;
        Services.StartAll;
        Application.Run;
        fSCMain.Visible := false;
        fSCMain.Free;
        Tareas.CancelarTodas;
        Tareas.Free;
        Services.StopAll;
        Data.Free;
      end;
      ConfiguracionVisual.Free;
    end
    else
      ShowMensaje('Error', ERROR_BD, mtError, [mbOK]);
  finally
    GlobalInit.GlobalFinalization;
  end;
end.




