void setup() {
  pinMode(9, OUTPUT);

  // Configurar Timer1 para Fast PWM 8-bit
  TCCR1A = _BV(COM1A1) | _BV(WGM10); // Fast PWM, salida en OC1A (pin 9)
  TCCR1B = _BV(WGM12) | _BV(CS10);   // sin prescaler, f_clk = 16 MHz

  OCR1A = 66; // duty = 26% → 66/255 ≈ 0.26
}

void loop() {
  // Si quieres actualizar el duty dinámicamente
  // OCR1A = nuevo_valor;
}
