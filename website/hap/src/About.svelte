<script>
    import CollapsibleSection from './CollapsibleSection.svelte'
</script>

<!-- <div class="about-wide"> -->
    <!-- <div class="about-content-top"> -->
        <CollapsibleSection isVisible={true} headerText={'Submit photos and information! '} >
        <p class="t4 ws qual">Share information about public access sites: The Hudson Access Project was created to make 
            it easier for everyone — especially people in areas with fewer resources and communities with fewer blue 
            spaces — to find their way onto the water. We also want to make it easier for people with mobility or 
            other concerns to understand how accessible each site is. We welcome your input! Please send us your 
            photographs, corrections, feedback and new information, especially details that support our goals to 
            increase accessibility for everyone. Photos and information can be submitted 
            through <a href="https://forms.gle/7mz519nRxRUUMstX9" target="_blank">this survey</a>. 
        </p>
        <!-- <p class="t4 ws"> 
            If you have any comments, or photos of a site that we can use on the Hudson Access Project website, please fill out <a href="https://forms.gle/7mz519nRxRUUMstX9" target="_blank">this form</a>.
        </p> -->
    </CollapsibleSection>
    <!-- </div>   -->
    <CollapsibleSection isVisible={false} headerText={'About the map'} >
        <!-- <div class="about-content"> -->
            <!-- The Hudson Access Project is collecting information about all the places where the public 
            can get into and onto the water in the Hudson & Harbor <span class="estuary" title="An estuary is any body of water where tidal ocean waters mix with fresh water from rivers and streams. The impact of tides and saltwater reaches all the way to Troy, NY and this map covers all the area of the estuary from the NY-NJ Harbor estuary to the northern reach of the Hudson at Troy. ">Estuary</span> and its tributaries for swimming, boating, 
            and fishing; with a focus on activities that bring people into direct contact with the water. The project 
            is ongoing and we welcome information and feedback. Please put the tool to use so you can test it and 
            help us improve it. -->
            <p class="t4 ws">The Hudson Access Project was created by a small team at Pratt Institute led by Sara Eichner and Sara Hodges with collaborative support from the NY-NJ Harbor & Estuary Program. 
                It is hosted at Pratt Institute’s Recover Adapt Mitigate Plan (RAMP) program in the Graduate Center for Planning and the Environment and funded by a River Access Grant awarded by the New York State Department of Environmental Conservation. The NY-NJ Harbor & Estuary Program has facilitated a relationship with the Public Access Working Group which has provided valuable insight into issues around public access, water safety and data. Additional funding was awarded to the project in 2023 by the Pratt Center Taconic Fellowship.
            </p>
            <p class="t4 ws top"> 
                Current Graduate Assistants:
            </p>
            <p class="t4 ws2"> 
                Nicholas Conklin
            </p>
            <p class="t4 ws2">
                Shahadat Hossain
            </p>
            <p class="t4 ws top"> 
               Former Team and Collaborators:
            </p>
            <p class="t4 ws2"> 
                Pratt Institute’s Spatial Analysis and Visualization Initiative
            </p>
            <p class="t4 ws2">
                Can Sucuoglu
            </p>
            <p class="t4 ws2">
                Alyssa Bement
            </p>
            <p class="t4 ws top"> 
                Follow us:
             </p>
            <p class="t4 ws2">
                <a href="https://www.instagram.com/hudson_access/" target="_blank">
                    <img src="hudsonaccessproject/assets/icons/social/instagram.svg" alt="Instagram" class="insta"/>
                </a>
                <a href="https://twitter.com/hudson_access/" target="_blank">
                    <img src="hudsonaccessproject/assets/icons/social/x-logo-black.png" alt="X" class="twit"/>
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