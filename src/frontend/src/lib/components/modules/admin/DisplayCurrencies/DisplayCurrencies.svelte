<script lang="ts">
    import { allowedCurrencies } from "$lib/data/stores/currencyStore";
    let currencies: string[] = [];
  
    $: allowedCurrencies.subscribe(value => {
      currencies = value;
    });
  </script>
  
  <div class="p-4">
    <h2 class="text-xl font-bold mb-4">Allowed Currencies</h2>
    {#if currencies.length === 0}
      <p>No currencies set yet.</p>
    {:else}
      <ul>
        {#each currencies as currency}
          <li>{currency}</li>
        {/each}
      </ul>
    {/if}
  </div>
  