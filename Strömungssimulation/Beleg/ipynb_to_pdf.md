1. jupyter nbconvert --to html beleg_sfi.ipynb
2. paste in html after <title>beleg_sfi</title><script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.10/require.min.js"></script>:

<style>
@page {
  margin: 20mm;
}
@page {
  @bottom-center {
    content: "Seite " counter(page);
  }
}
</style>

3. open html in browser and print to pdf
