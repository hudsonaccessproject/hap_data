<script>
    import CollapsibleSection from './CollapsibleSection.svelte'
</script>

<!-- <div class="about-wide"> -->
    <CollapsibleSection isVisible={true} headerText={'Instructions'} >
        <p class="t4 ws qual">
            Use the Hudson Access Project to find locations where you can get into and onto the Hudson River and harbor estuary.  
            The site includes fishing, swimming, human-powered boating, motor-powered boating, and community science / educational 
            opportunities.  Click on the activity and amenity filters to highlight sites that offer those amenities or activities – each 
            site that meets your criteria will turn orange in the map and a list of sites will be shown underneath the filters. You can 
            click on any site in the map or in the list to zoom-in to the location and view information about accessibility, amenities, 
            facilities, regulations, and more.  
        </p>
        <p class="t4 ws">Want to find sites with fishing, running water and bathrooms?</p>
        <ul class="t4">
            <li>Click on the "Fish" icon in the activity filter and</li>
            <li>Click "Search by amenity" to expand the list and select "Restroom" and "Drinkable / running water" in the amenity filter</li>
        </ul>
        <p class="t4 ws">Want to find sites with programming to try out kayaking?  </p>
        <ul class="t4">
            <li>Click on the “Human-Powered Boating” icon in the activity filter and </li>
            <li>Click “Search by amenity” to expand the list and select “Programming” in the amenity filter </li>
        </ul>
        <p class="t4 ws">You can also search for a location by typing the name in “Search by site name”.</p>
        <p class="t4 ws">The Hudson Access Project database is a work in progress. Due to the dynamic nature of public space and land use, the 
            data is always changing and some data is difficult to find. Please be sure to check with the site you plan to visit and programs 
            you intend to participate in before heading out. This website provides current links for each site and program where we can find 
            one. Because information can change or be incomplete, also be sure to refer to any safety guidelines, rules and hazard information 
            at each recreation site you visit. While we hope you will use the HAP Water Safety and Water Quality tabs as resources, don’t 
            rely solely on information on this website for safety.
        </p>
        <p class="t4 ws">The database was created from multiple sources retrieved from counties, municipalities, non profit organizations, New 
            Jersey and New York states. The Hudson Access Project  continues to work to validate that data and to fill in the significant gaps 
            that still exist. We encourage contributions, corrections and photos from the public to help with this ongoing process. Please 
            submit them <a href="https://forms.gle/7mz519nRxRUUMstX9" target="_blank">here</a>. Thank you!
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'Submit photos and information! '} >
        <p class="t4 ws qual">Share information about public access sites: The Hudson Access Project was created to make 
            it easier for everyone — especially people in areas with fewer resources and communities with fewer blue 
            spaces — to find their way onto the water. We also want to make it easier for people with mobility or 
            other concerns to understand how accessible each site is. We welcome your input! Please send us your 
            photographs, corrections, feedback and new information, especially details that support our goals to 
            increase accessibility for everyone. Photos and information can be submitted 
            through <a href="https://forms.gle/7mz519nRxRUUMstX9" target="_blank">this survey</a>. 
        </p>
    </CollapsibleSection>
    <CollapsibleSection isVisible={false} headerText={'About the map'} >
        <p class="t4 ws" xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://www.hudsonriver.org/hudsonaccessproject/">Hudson Access Project</a> by <span property="cc:attributionName">Pratt Institute 
            RAMP program, <a href="https://spatialcollections.com/" target="_blank">spatial collections</a>, and <a href="https://www.studio2263.com/" target="_blank">Studio 2263</a>. This Project has been funded in part by a grant from the NY State Department of Environmental Conservation’s 
            Hudson River Estuary Program. As well as funding from the NY-NJ Harbor Estuary Program, and the Pratt Center Taconic Fellowship</span> is licensed
             under <a href="https://creativecommons.org/licenses/by-nc-sa/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">CC BY-NC-SA 4.0<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/nc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1" alt=""></a></p>  
        <p class="t4 ws">The Hudson Access Project was created by a small team at Pratt Institute led by Sara Eichner and Sara Hodges with collaborative support from the NY-NJ Harbor & Estuary Program. 
                It is hosted at Pratt Institute’s Recover Adapt Mitigate Plan (RAMP) program in the Graduate Center for Planning and the Environment and funded by a River Access Grant awarded by the New York State Department of Environmental Conservation. The NY-NJ Harbor & Estuary Program has facilitated a relationship with the Public Access Working Group which has provided valuable insight into issues around public access, water safety and data. Additional funding was awarded to the project in 2023 by the Pratt Center Taconic Fellowship.
            </p>
            <!-- <p class="t4 ws top"> 
                Current Graduate Assistants:
            </p>
            <ul class="t4">
                <li>Nicholas Conklin</li>
                <li>Shahadat Hossain</li>
            </ul> -->
            <p class="t4 ws top"> 
               Thank you to our former team and collaborators:
            </p>
            <ul class="t4">
                <li>Pratt Institute’s Spatial Analysis and Visualization Initiative</li>
                <li>Can Sucuoglu</li>
                <li>Alyssa Bement</li>
                <li>Nicholas Conklin</li>
                <li>Shahadat Hossain</li>
            </ul>
            <p class="t4 ws top"> 
                Follow us:
             </p>
            <p class="t4 ws2">
                <a href="https://www.instagram.com/hudson_access/" target="_blank">
                    <img src="/hudsonaccessproject/assets/icons/social/instagram.svg" alt="Instagram" class="insta"/>
                </a>
                <a href="https://twitter.com/hudson_access/" target="_blank">
                    <img src="/hudsonaccessproject/assets/icons/social/x-logo-black.png" alt="X" class="twit"/>
                </a>
            </p>
            <p class="t4 ws2"> 
                Email: hudsonaccessproject@gmail.com
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
        <!-- <p class="t4 ws">The Hudson Access Project was created by Sara Eichner, Sara Hodges and Pratt Institute graduate assistant, Alyssa Bement. 
            We can all be reached at: hudsonaccessproject@gmail.com
        </p> -->
    </CollapsibleSection>
<!-- </div> -->

<style>

    /* .about-wide { */
        /* position: absolute; */
        /* top: 66px; */
        /* z-index: 10001;
        background-color: #fff; */
        /* height: calc(100% - 65px); */
    /* } */

    /* .about-content {
        padding-top: 20px;
        padding-bottom: 20px;
    }
    .about-content-top {
        padding-top: 20px !important;
    } */
    /* @media (max-width: 767px) {
        .about-wide {
            top: 75px;
            height: calc(100% - 75px);
        }
    } */

</style>