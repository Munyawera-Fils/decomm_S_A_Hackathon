<script lang="ts">
    import { walletAddresses } from "$lib/data/stores/walletStore";
    let walletAddress = '';
  
    function saveAddress() {
      walletAddresses.update(addresses => {
        // Add the new address to the list and return the updated list
        return [...addresses, walletAddress];
      });
      walletAddress = ''; // Clear the input after saving
    }
  </script>
  
  <div class="p-4">
    <h2 class="text-xl font-bold mb-4">Add Wallet Address where your sales amount will be deposited</h2>
    <label for="walletAddress" class="block mb-2">Wallet Address:</label>
    <input
      id="walletAddress"
      type="text"
      bind:value={walletAddress}
      placeholder="Enter wallet address"
      class="w-full p-2 border border-gray-300 rounded"
    />
    <button
      on:click={saveAddress}
      class="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
    >
      Save Address
    </button>
  </div>
  