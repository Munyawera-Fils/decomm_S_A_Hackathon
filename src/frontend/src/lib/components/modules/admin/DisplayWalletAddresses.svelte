<script lang="ts">
    import { walletAddresses } from "$lib/data/stores/walletStore";
    let addresses: string[] = [];
  
    // Subscribe to the store
    $: walletAddresses.subscribe(value => {
      addresses = value;
    });
  </script>
  
  <div class="p-4">
    <h2 class="text-xl font-bold mb-4">Saved Wallet Addresses</h2>
    {#if addresses.length === 0}
      <p>No wallet addresses saved yet.</p>
    {:else}
      <ul>
        {#each addresses as address}
          <li>{address}</li>
        {/each}
      </ul>
    {/if}
  </div>
  