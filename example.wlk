
// ============ NAVE ============
class Nave {
  var velocidad
  var dirAlSol = 0
  var combustible 

  method cargarComustible(cant) {
    combustible = combustible + cant
  }
  method descargarComustible(cant) {
    combustible = 0.max(combustible - cant)
  }
  method acelerar(cuanto) {
    velocidad = 100000.min(velocidad + cuanto)
  }

  method desacelerar(cuanto){
    velocidad = 0.max(velocidad - cuanto)
  }

  method irHaciaElSol(){ dirAlSol = 10 }
  method escaparDelSol(){ dirAlSol = -10 }
  method ponerseParaleloAlSol(){ dirAlSol = 0} 

  method acercarseUnPocoAlSol(){ dirAlSol = (dirAlSol + 1).min(10) }

  method alejarseUnPocoDelSol() { dirAlSol = (dirAlSol - 1).max(-10) }

  method prepararViaje(){
    self.cargarComustible(30000)
    self.acelerar(5000)
    self.accionAdicional()
  }  

  method accionAdicional() //method abstract
  method estaTranquila(){
    return 
      combustible >= 4000 &&
      velocidad < 12000 &&
      self.condicionAdicional()
  }

  method condicionAdicional() // method abastract 
  method recibirAmenaza(){
    self.escapar()
    self.avisar()
  }

  method escapar()
  method avisar()

  method estaDeRelajo(){
    return
      self.estaTranquila() &&
      self.tienePocaActividad()
  }
  method tienePocaActividad()
}

// ============ NAVE BALIZA ============
class NaveBaliza inherits Nave {
  var colorBaliza
  var cambioBaliza = false

  method cambiarColorBaliza(colorNuevo){
    colorBaliza = colorNuevo
    cambioBaliza = true
  }
  override method accionAdicional(){
    self.cambiarColorBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method condicionAdicional(){
    colorBaliza != "rojo"
  }
  override method escapar(){
    self.irHaciaElSol()
  }
  override method avisar(){
    self.cambiarColorBaliza("Rojo")
  }
  override method tienePocaActividad(){
    return 
      !cambioBaliza
  }
}
// ============ NAVE PASAJEROS ============
class NavePasajeros inherits Nave{
  const pasajeros
  var comida = 0
  var bebida = 0

  var comidaServida = 0

  method cargar(cantBebidas,cantComidas){
    bebida = bebida +  cantBebidas
    comida = comida +  cantComidas
  }

  method descargar(cantBebidas,cantComidas){
    bebida = 0.max(bebida -  cantBebidas)
    comida = 0.max(comida -  cantComidas)
    comidaServida += cantComidas
  }
  override method accionAdicional() {
    self.cargar(4*pasajeros, 6*pasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method condicionAdicional(){
      return true
  }
  override method escapar(){
    self.acelerar(velocidad)
  }
  override method avisar(){
    self.descargar(2*pasajeros, pasajeros)
  }
  override method tienePocaActividad()= comidaServida < 50
}
// ============ NAVE COMBATE ============
class NaveCombate inherits Nave{
  var visible = true
  var misilesDesplegados = false
  const mensajes = [] 
  method ponerseVisible(){ visible = true }
  method ponerseInvisible() { visible = false }
  method estaInvisible() = !visible
  method misiblesDesplegados() = misilesDesplegados
  method desplegarMisiles() { misilesDesplegados = true}
  method replegarMisiles() { misilesDesplegados = false }
  method emitirMensaje(mensaje){ mensajes.add(mensaje) }
  method mensajesEmitidos() = mensajes.size()
  method primerMensajeEmitido() {
    if (mensajes.isEmpty()){
      self.error("La lista mensajes esta vacia")
    }
    return mensajes.first()
  }

  method ultimoMensajeEmitido() {
    if (mensajes.isEmpty()){
      self.error("La lista mensajes esta vacia")
    }
    return mensajes.last()
  }

  method esEscueta(){
    return mensajes.all({m=>m.length()<30})
  }

  method emitioMensaje(mensaje){
    mensajes.contains(mensaje)
  }
  
  override method accionAdicional(){
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en Misión")
  }
  override method condicionAdicional(){
    return 
      !misilesDesplegados
  }
  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar(){
    self.emitirMensaje("Amenaza recibida")
  }
  override method tienePocaActividad() = true
}
// ============ NAVE HOSPITAL ============
class NaveHospital inherits NavePasajeros {
  var quirofanoPreparados = true

  override method condicionAdicional(){
    return !quirofanoPreparados
  }
  method prepararQuirofanos() {
    quirofanoPreparados = true
  }
  override method recibirAmenaza(){
    super()
    self.prepararQuirofanos()
  }
  override method tienePocaActividad() = true
}
// ============ NAVE SIGILOSA ============
class NaveSigilosa inherits NaveCombate {

  override method condicionAdicional(){
    return 
      super() && !self.estaInvisible()
  }
  override method escapar(){
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
  override method tienePocaActividad() = true
}