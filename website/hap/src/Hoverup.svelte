<script>
    export let acts;
    // console.log( acts);

</script>


<div class="hoverup">
    <p class="t2">About Target Ecosystem Characteristics</p>
    <div class="grid-container">
    {#each acts as act}
        <div class='grid-item'>
            <img alt={act.value} style="width:35px" src= {act.source}/>
            <div style="margin-left:5px">
                <div id="hover-title">{act.name}</div>
                <div id="hover-text">{act.desc}</div>
            </div>
        </div>
    {/each}

    </div>
</div>

<style>

    #hover-title{
        font-size: 9pt;
        font-weight: 700;
        color:#666;
        line-height: 0.9rem;
    }

    #hover-text{
        font-size: 9pt;
        font-weight: 400;
        color:#888;
        line-height: 0.85rem;
    }

    .hoverup{
        padding: 5px 20px 15px 10px;
        position: absolute;
        background: white;
        max-width: 500px;
        top:100px;
        left:310px;
        border-radius: 8px;
        z-index:6;
        border: 1px solid rgba(0, 0, 0, 0.2);
        box-shadow: 5px 5px rgba(0, 0, 0, 0.1);
    }

    .grid-container {
        display: flex;
        flex-direction: column;
        flex-wrap: wrap;
        margin-top: 10px;
        max-height: 650px;
    }

    .grid-item {
        display: grid;
        max-width: 48%;
        grid-template-columns: 0.3fr 1fr;
        padding-bottom: 8px;
        padding-top: 4px;
        padding-right: 20px;
    }

    img{
        margin-top: 0px;
    }


</style>