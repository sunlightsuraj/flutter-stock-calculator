class MyStock {
  double rate;
  double qty;
  double total;

  MyStock(rate, qty) {
    this.rate = rate;
    this.qty = qty;
    this.total = this.rate * this.qty;
  }
  
}