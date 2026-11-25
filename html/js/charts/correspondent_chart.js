window.addEventListener("load", function () {
  // DataTables 2: get the instance that datatables_custom.js already created
  // sign: +1 = Tillich is recipient (up), -1 = Tillich is sender (down)
  
  function render() {
      const SERIES = [
        { key: "sent_to_main",          name: "Brief an Tillich",              sign: 1,  color: "#2f6f9f" },
        { key: "corecipient_with_main", name: "Gemeinsam mit Tillich empfangen", sign: 1,  color: "#8fb8d6" },
        { key: "third_party",           name: "Zwischen Dritten",              sign: 1,  color: "#bdbdbd" },
        { key: "received_from_main",    name: "Brief von Tillich",             sign: -1, color: "#b5532a" },
        { key: "cosender_with_main",    name: "Gemeinsam mit Tillich verfasst", sign: -1, color: "#e0a57f" },
      ];
   const counts = {}; // { year: { direction: n } }
// rows().nodes() returns the <tr> of ALL rows, not only page 1
 table
    .rows({ search: "applied" })   // only the rows that pass the current filter
    .nodes()
    .toArray()
    .forEach((tr) => {
      const year = tr.dataset.year;
      const dir = tr.dataset.direction;
      if (!/^\d{4}$/.test(year) || year === "9999") return;
      counts[year] = counts[year] || {};
      counts[year][dir] = (counts[year][dir] || 0) + 1;
    });

  const years = Object.keys(counts).map(Number);
  const el = document.getElementById("direction-chart");
  if (years.length === 0) { el.innerHTML = ""; return; }  // nothing matches the filter

  const categories = [];
  for (let y = Math.min(...years); y <= Math.max(...years); y++) categories.push(String(y));

  Highcharts.chart("direction-chart", {
    chart: { type: "column" },
    title: { text: "Briefe pro Jahr" },
    xAxis: { categories },
    yAxis: {
      title: { text: null },
      labels: { formatter() { return Math.abs(this.value); } },
    },
    plotOptions: { series: { stacking: "normal" } },
    tooltip: {
      shared: true,
      formatter() {
        const year = this.points[0].key;
        return `<b>${year}</b><br>` +
          this.points
            .filter(p => p.y !== 0)
            .map(p => `${p.series.name}: <b>${Math.abs(p.y)}</b>`)
            .join("<br>");
      },
    },
    series: SERIES.map(s => ({
      name: s.name,
      color: s.color,
      data: categories.map(y => s.sign * ((counts[y] && counts[y][s.key]) || 0)),
    })),
    credits: { enabled: false },
  });
  }

  render();
  table.on("draw", render);
});