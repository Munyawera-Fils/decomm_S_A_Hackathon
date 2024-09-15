<script lang="ts">
    import { allowedCurrencies } from "$lib/data/stores/currencyStore";
    let currency = '';
  
    function addCurrency() {
      allowedCurrencies.update(currencies => {
        if (!currencies.includes(currency)) {
          return [...currencies, currency];
        }
        return currencies;
      });
      currency = ''; // Clear the input after adding
    }
  </script>
  
  <div class="p-4">
    <h2 class="text-xl font-bold mb-4">Add Allowed Currency</h2>
    <label for="currency" class="block mb-2">Currency (Token):</label>
    <input
      id="currency"
      type="text"
      bind:value={currency}
      placeholder="Enter currency token"
      class="w-full p-2 border border-gray-300 rounded"
    />
    <button
      on:click={addCurrency}
      class="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
    >
      Add Currency
    </button>
  </div>
  