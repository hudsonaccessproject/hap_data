<script>
    import CollapsibleSection from './CollapsibleSection.svelte'
</script>

<div class="about-wide">
    <div class="about-content-top">
        <p class="t4 ws qual">The Hudson Access Project is collecting information about all the places where the public 
            can get into and onto the water in the Hudson & Harbor <span class="estuary" title="An estuary is any body of water where tidal ocean waters mix with fresh water from rivers and streams. The impact of tides and saltwater reaches all the way to Troy, NY and this map covers all the area of the estuary from the NY-NJ Harbor estuary to the northern reach of the Hudson at Troy. ">Estuary</span> and its tributaries for swimming, boating, 
            and fishing; with a focus on activities that bring people into direct contact with the water. The project 
            is ongoing and we welcome information and feedback. Please put the tool to use so you can test it and 
            help us improve it.

        </p>
    </div>  
    <CollapsibleSection isVisible={true} headerText={'Share Information!'} >
        <div class="about-content">
            <p class="t4 ws">The Hudson Access Project has specific priorities in data collection: we want to make it easier for 
                people in areas with fewer resources, and communities with fewer blue spaces, to find their way onto the water 
                more easily. We also want to make it easier for people with mobility or other concerns to understand how 
                accessible each site listed is. Please share information supporting these goals if you have it. 

            </p>
            <p class="t4 ws">
                The website you are using is a beta version. It was created by a small team at the Pratt Spatial Analysis and 
                Visualization Initiative over the last 1.5 years as part of a River Access Grant awarded by the New York State 
                Department of Environmental Conservation. The NY-NJ Harbor & Estuary Program was a collaborator on this effort 
                and facilitated the important support and advisory role that  their Public Access Working Group was able to provide.  
            </p>
            <p class="t4 ws">
                Data collection and field research will be conducted for 10 weeks this summer to improve the information you 
                see here.  We will integrate new data into the site periodically throughout the summer. Please follow us on 
                Instagram or twitter to find out when updates occur. And send us an email if you want to learn more or access 
                the dataset as a resource for research about public access.  
            </p>
        </div>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Contact Us'} >
        <p class="t4 ws"> 
            <a href="https://twitter.com/hudson_access/" target="_blank">Twitter</a>
        </p>
        <p class="t4 ws"> 
            <a href="https://www.instagram.com/hudson_access/" target="_blank">Instagram</a>
        </p>
        <p class="t4 ws"> 
            Email: Hudsonaccessproject@gmail.com
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Thank you'} >
        <p class="t4 ws">Supported by HEP, HRF and public access working group (PAWG)
        </p>
        <ul>
            <li class="t4 ws"><a href="https://www.scenichudson.org/" target="_blank">Scenic Hudson</a></li>
            <li class="t4 ws"><a href="https://waterfrontaccess.planning.nyc.gov/about#10/40.7097/-73.9653" target="_blank">NYC WAP</a></li>
            <li class="t4 ws"><a href="https://www.nycwatertrail.org/map.html" target="_blank">NY Water Trails</a></li>
            <li class="t4 ws"><a href="https://www.traillink.com/trail-maps/hudson-river-greenway/" target="_blank">Hudson River Greenway</a></li>
            <li class="t4 ws"><a href="https://bronxriver.org/wp-content/uploads/2021/05/Get-Moving-on-the-Bronx-River-2016-Activity-Guide1.pdf
                " target="_blank">Bronx River Alliance Greenway Guide</a></li>
        </ul>
        <p class="t4 ws">The Hudson Access Project was created by Sara Eichner, Sara Hodges and Pratt Institute graduate assistant, Alyssa Bement. 
            We can all be reached at: hudsonaccessproject@gmail.com
        </p>
    </CollapsibleSection>
</div>

<style>

    .about-wide {
        position: absolute;
        top: 65px;
        z-index: 10001;
        background-color: #fff;
        height: calc(100% - 65px);
    }

    .about-content {
        padding-top: 20px;
        padding-bottom: 20px;
    }
    .about-content-top {
        padding-top: 20px !important;
    }
    @media (max-width: 767px) {
        .about-wide {
            top: 175px;
            height: calc(100% - 175px);
        }
    }
    /* .ws {
        padding: 0 2.5%;
    }
    .qual {
        padding-top: 5px;
        padding-bottom: 5px;
    }
    .estuary {
        cursor: pointer;
        font-weight: 700;
    }

    .estuary:hover {
        text-decoration: underline;
    } */
</style>